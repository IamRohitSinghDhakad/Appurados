//
//  TrackOrderViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 16/09/21.
//

import UIKit
import GoogleMaps

class TrackOrderViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var mapVw: GMSMapView!
    @IBOutlet weak var lblEstimateTime: UILabel!
    @IBOutlet weak var vwOne: UIView!
    @IBOutlet weak var vwTwo: UIView!
    @IBOutlet weak var vwThree: UIView!
    @IBOutlet weak var vwFour: UIView!
    @IBOutlet weak var vwFive: UIView!
    @IBOutlet weak var vwSix: UIView!
    
    var pickUpMarker = GMSMarker()
    var dropUpMarker = GMSMarker()
    var driverMarker = GMSMarker()
    
    var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    var isRunFirstTime = Bool()
    
    
    var strOrderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetOrderID(strOrderID: strOrderID)
        
        // Do any additional setup after loading the view.
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: self.mapVw.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
       
        mapView.delegate = self
        // Add the map to the view, hide it until we've got a location update.
        self.mapVw.addSubview(mapView)
        mapView.isHidden = false
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }

}

// Delegates to handle events for the location manager.
extension TrackOrderViewController {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
   
//    marker.map = nil
//    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//    marker.title = "My location"
//  //  marker.snippet = "Australia"
//    marker.map = mapView
    
    let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)
    
    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Check accuracy authorization
    let accuracy = manager.accuracyAuthorization
    switch accuracy {
    case .fullAccuracy:
        print("Location accuracy is precise.")
    case .reducedAccuracy:
        print("Location accuracy is not precise.")
    @unknown default:
      fatalError()
    }

    // Handle authorization status
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
    
    func resetStatus(){
        self.vwOne.backgroundColor = UIColor.white
        self.vwTwo.backgroundColor = UIColor.white
        self.vwThree.backgroundColor = UIColor.white
        self.vwFour.backgroundColor = UIColor.white
        self.vwFive.backgroundColor = UIColor.white
        self.vwSix.backgroundColor = UIColor.white
    }
}


extension TrackOrderViewController {
    
    
    //MARK:- Vendor Count Product
    func call_WsGetOrderID(strOrderID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "order_id":strOrderID]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOrders, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                print(response)
                
                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = OrdersDetailModel.init(dict: data)
                        
                        self.lblEstimateTime.text = obj.strEstimateTime
                        
                        if self.isRunFirstTime == false{
                            self.isRunFirstTime = true
                            
                            self.pickUpMarker.map = nil
                            self.pickUpMarker.position = CLLocationCoordinate2D(latitude: obj.pickLat, longitude: obj.pickLong)
                            self.pickUpMarker.title = "PickUp Location"
                            self.pickUpMarker.map = self.mapView
                            
                            let camera = GMSCameraPosition.camera(withLatitude: obj.pickLat,
                                                                  longitude: obj.pickLong,
                                                                  zoom: self.preciseLocationZoomLevel)
                            
                            self.mapView.camera = camera
                            self.mapView.animate(to: camera)
                            
                            
                            self.dropUpMarker.map = nil
                            self.dropUpMarker.position = CLLocationCoordinate2D(latitude: obj.dropLat, longitude: obj.dropLong)
                            self.dropUpMarker.title = "drop Location"
                            self.dropUpMarker.map = self.mapView
                            
                            
                        }else{
                            print(obj.driverLat)
                            if obj.driverLat != 0.0{
                                self.driverMarker.map = nil
                                self.driverMarker.position = CLLocationCoordinate2D(latitude: obj.dropLat, longitude: obj.dropLong)
                                self.driverMarker.title = "driver Location"
                                self.driverMarker.map = self.mapView
                                
                                let camera = GMSCameraPosition.camera(withLatitude: obj.driverLat,
                                                                      longitude: obj.driveLong,
                                                                      zoom: self.preciseLocationZoomLevel)
                                
                                self.mapView.camera = camera
                                self.mapView.animate(to: camera)
                                
                            }else{
                                
                            }
                            
                            self.resetStatus()
                            switch obj.status {
                            case "pending":
                                self.vwOne.backgroundColor = UIColor.init(named: "AppColor")
                            case "accept":
                                self.vwTwo.backgroundColor = UIColor.init(named: "AppColor")
                            case "shipped":
                                self.vwThree.backgroundColor = UIColor.init(named: "AppColor")
                            case "accepted":
                                self.vwFour.backgroundColor = UIColor.init(named: "AppColor")
                            case "picked":
                                self.vwFive.backgroundColor = UIColor.init(named: "AppColor")
                            default:
                                self.resetStatus()
                                self.vwSix.backgroundColor = UIColor.init(named: "AppColor")
                            }
                        }
                    }
                    
                    
                  //  self.tblOrdersList.reloadData()
                    
                }else{
                    //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
