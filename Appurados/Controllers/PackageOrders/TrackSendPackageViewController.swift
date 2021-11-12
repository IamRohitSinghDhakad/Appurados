//
//  TrackSendPackageViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 09/10/21.
//

import UIKit
import GoogleMaps

class TrackSendPackageViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblEstimateTime: UILabel!
    @IBOutlet weak var mapVw: UIView!
    
    var userSelectedLatitude : Double?
    var userSelectedLongitude : Double?
    var currentLocationStr = "Current location"
    var pickUpMarker = GMSMarker()
    var dropUpMarker = GMSMarker()
    var driverMarker = GMSMarker()
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var locationManager: CLLocationManager!
    var pickLatitude:Double = 0.0
    var pickLongitude:Double = 0.0
    var dropLatitude:Double = 0.0
    var dropLongitude:Double = 0.0
    var timer: Timer?
    
    var objPackageDetails:SendPackageModel?
    var isRunFirstTime = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapInitilize()
        self.call_WsTrackPackage()
        
        if self.timer == nil{
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }else{

        }
    }
    
    
    @objc func updateTimer() {
        //example functionality
        self.call_WsTrackPackage()
    }
    
    
    func mapInitilize(){
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: self.pickLatitude, longitude: self.pickLongitude)
        
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
      
    
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.addMarker()
//        }

    }
    
    
    func addMarker(){
        
        pickUpMarker.map = nil
        pickUpMarker.position = CLLocationCoordinate2D(latitude: pickLatitude, longitude: pickLongitude)
        self.pickUpMarker.title = "Selected location"
        self.pickUpMarker.map = self.mapView
     
        dropUpMarker.map = nil
        dropUpMarker.position = CLLocationCoordinate2D(latitude: dropLatitude, longitude: dropLongitude)
        
        DispatchQueue.main.async {
            
            self.dropUpMarker.title = "Selected location"
            //  marker.snippet = "Australia"
            self.dropUpMarker.map = self.mapView
            let zoomLevel = self.locationManager.accuracyAuthorization == .fullAccuracy ? self.preciseLocationZoomLevel : self.approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: self.dropLatitude,
                                                  longitude: self.dropLongitude,
                                                  zoom: zoomLevel)
            self.mapView.animate(to: camera)
        }
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
     
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
        
    }
  

}


extension TrackSendPackageViewController{
    
    func call_WsTrackPackage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        if self.isRunFirstTime == false{
            objWebServiceManager.showIndicator()
        }
       
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "package_delivery_id":objPackageDetails!.strPackageDeliveryID]as [String:Any]
        
        print(dicrParam)
                
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetPackageDelivery, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { response in
        
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                print(response)
                
                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = OrdersDetailModel.init(dict: data)
                        
                        self.lblEstimateTime.text = obj.strEstimateTimeForTrack
                        self.lblDistance.text = obj.strDistanceForTrack + "KM"
                        
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
                            if obj.driverLat != 0.0{
                                self.driverMarker.map = nil
                                self.driverMarker.position = CLLocationCoordinate2D(latitude: obj.driverLat, longitude: obj.driveLong)
                                self.driverMarker.title = "driver Location"
                                self.driverMarker.map = self.mapView
                                self.driverMarker.icon = UIImage.init(named: "bike_ride_new")
                                
                                let camera = GMSCameraPosition.camera(withLatitude: obj.driverLat,
                                                                      longitude: obj.driveLong,
                                                                      zoom: 18)
                                
                                self.mapView.camera = camera
                                self.mapView.animate(to: camera)
                                
                            }else{
                                
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
