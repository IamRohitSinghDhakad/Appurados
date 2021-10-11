//
//  ConfirmPackageViewController.swift
//  Appurados
//
//  Created by Rohit Dhakad on 05/10/21.
//

import UIKit
import GoogleMaps

class ConfirmPackageViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapVw: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtVwSpeciaslInstruction: RDTextView!
    @IBOutlet weak var imgVwCheckOnline: UIImageView!
    @IBOutlet weak var imgVwCheckCash: UIImageView!
    
    var userSelectedLatitude : Double?
    var userSelectedLongitude : Double?
    var currentLocationStr = "Current location"
    var pickUpmarker = GMSMarker()
    var dropUpMarker = GMSMarker()
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var strPaymentMode = ""
    var dictPackageData = [String:Any]()
    var locationManager: CLLocationManager!
    var pickLatitude:Double = 0.0
    var pickLongitude:Double = 0.0
    var dropLatitude:Double = 0.0
    var dropLongitude:Double = 0.0
    var strPickAddress = ""
    var strDropAddress = ""
    var strPickLandmark = ""
    var strDropLandmark = ""
    var strReceivernNumber = ""
    var strReceiverName = ""
    var strEstimatedTime = ""
    var strAmount = ""
    var strDate = ""
    var strDistance = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.dictPackageData)
        mapInitilize()
        self.getUserData()
       
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func getUserData(){
        
        self.strPickAddress = self.dictPackageData["pickAddress"] as? String ?? ""
        self.strDropAddress = self.dictPackageData["receiverAddress"]as? String ?? ""
        self.strPickLandmark = self.dictPackageData["pickLandmark"]as? String ?? ""
        self.strDropLandmark = self.dictPackageData["receiverLandmark"]as? String ?? ""
        self.strReceivernNumber = self.dictPackageData["Phone"] as? String ?? ""
        strReceiverName = self.dictPackageData["Name"] as? String ?? ""
        self.strDate = Date().shortDate
        self.pickLatitude = Double(self.dictPackageData["pickLatitude"]as? Double ?? 0.0)
        self.pickLongitude = Double(self.dictPackageData["pickLongitude"]as? Double ?? 0.0)
        self.dropLatitude = Double(self.dictPackageData["receiverLatitude"]as? Double ?? 0.0)
        self.dropLongitude = Double(self.dictPackageData["receiverLongitude"]as? Double ?? 0.0)
        
        self.call_WsGetDeliveryCharge()
        
        //"drop_landmark": ""
        //amount
        //estimated_time
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
      
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.addMarker()
        }
//
//        self.pickUpmarker.map = nil
//        self.pickUpmarker.position = CLLocationCoordinate2D(latitude: self.pickLatitude, longitude: self.pickLongitude)
//        self.pickUpmarker.title = "Pick location"
//        //  marker.snippet = "Australia"
//        self.pickUpmarker.map = self.mapView
//
////        let zoomLevel = 15.0
////        let camera = GMSCameraPosition.camera(withLatitude: pickLatitude,
////                                              longitude: pickLongitude,
////                                              zoom: Float(zoomLevel))
//
//
//        self.dropUpMarker.map = nil
//        self.dropUpMarker.position = CLLocationCoordinate2D(latitude: self.dropLatitude, longitude: self.dropLongitude)
//        self.dropUpMarker.title = "Drop location"
//        //  marker.snippet = "Australia"
//        self.dropUpMarker.map = self.mapView
//
////        let zoomLevelp = 15.0
////        let camera2 = GMSCameraPosition.camera(withLatitude: dropLatitude,
////                                              longitude: dropLongitude,
////                                              zoom: Float(zoomLevelp))
//
////        let camera = GMSCameraPosition.camera(withLatitude: self.pickLatitude, longitude: self.pickLongitude, zoom: 16)
////        self.mapView?.camera = camera
////        self.mapView?.animate(to: camera)
////
////        self.mapVw.animate(to: camera)
//
    }
    
    func addMarker(){
        
        pickUpmarker.map = nil
        pickUpmarker.position = CLLocationCoordinate2D(latitude: pickLatitude, longitude: pickLongitude)
        self.pickUpmarker.title = "Selected location"
        self.pickUpmarker.map = self.mapView
     
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaymentTypeOnline(_ sender: Any) {
        self.strPaymentMode = "online"
        self.imgVwCheckOnline.image = #imageLiteral(resourceName: "select")
        self.imgVwCheckCash.image = #imageLiteral(resourceName: "box")
    }
    
    @IBAction func btnPaymentTypeCash(_ sender: Any) {
        self.strPaymentMode = "cash"
        self.imgVwCheckOnline.image = #imageLiteral(resourceName: "box")
        self.imgVwCheckCash.image = #imageLiteral(resourceName: "select")
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if self.strPaymentMode == ""{
            objAlert.showAlert(message: "Please select payment mode", title: "Alert", controller: self)
        }else{
            self.call_WsPackageDelivery()
        }
    }
}


 
extension ConfirmPackageViewController{
    
    
    //MARK:- Send Package
    func call_WsGetDeliveryCharge(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["pick_lat":"\(self.pickLatitude)",
                         "pick_lng":"\(self.pickLongitude)",
                         "drop_lat":"\(self.dropLatitude)",
                         "drop_lng":"\(self.dropLongitude)"]as [String:Any]
        

       
        objWebServiceManager.requestGet(strURL: WsUrl.url_EstimateDeliveryCost, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                if let dictData = response["result"]as? [String:Any]{
                    
                  
                    if let cost = dictData["cost"]as? String{
                        self.lblPrice.text = "$" + cost
                        self.strAmount = cost
                    }else if let cost = dictData["cost"]as? Int{
                        self.lblPrice.text = "$\(cost)"
                        self.strAmount = "\(cost)"
                    }
                    
                    if let distance = dictData["distance"]as? String{
                        self.strDistance = distance
                    }
                    
                    if let time = dictData["time"]as? String{
                        self.strEstimatedTime = time
                    }
                    
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
    
    
    //MARK:- Package Delivery
    func call_WsPackageDelivery(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
       
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "sender_name":objAppShareData.UserDetail.strUserName,
                         "sender_mobile":objAppShareData.UserDetail.strPhoneNumber,
                         "pick_address":self.strPickAddress,
                         "receiver_name":self.strReceiverName,
                         "receiver_mobile":self.strReceivernNumber,
                         "pick_lat":"\(self.pickLatitude)",
                         "pick_lng":"\(self.pickLongitude)",
                         "drop_lat":"\(self.dropLatitude)",
                         "drop_lng":"\(self.dropLongitude)",
                         "drop_address":self.strDropAddress,
                         "estimated_time":self.strEstimatedTime,
                         "amount":self.strAmount,
                         "payment_mode":self.strPaymentMode,
                         "payment_status":"pending",
                         "date":self.strDate,
                         "pick_landmark":self.strPickLandmark,
                         "drop_landmark":self.strDropLandmark,
                         "instruction":self.txtVwSpeciaslInstruction.text!,
                         "status":"pending"]as [String:Any]
        

        print(dicrParam)
        objWebServiceManager.requestGet(strURL: WsUrl.url_PackageDelivery, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                if let dictData = response["result"]as? [String:Any]{
                    
                    let obj = SendPackageModel.init(dict: dictData)
                    print(obj)
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "TrackSendPackageViewController")as! TrackSendPackageViewController
                    vc.objPackageDetails = obj
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
           
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


extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }

    var fullDate: String   { localizedDescription(dateStyle: .full,   timeStyle: .none) }
    var longDate: String   { localizedDescription(dateStyle: .long,   timeStyle: .none) }
    var mediumDate: String { localizedDescription(dateStyle: .medium, timeStyle: .none) }
    var shortDate: String  { localizedDescription(dateStyle: .short,  timeStyle: .none) }

    var fullTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .full) }
    var longTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .long) }
    var mediumTime: String { localizedDescription(dateStyle: .none,   timeStyle: .medium) }
    var shortTime: String  { localizedDescription(dateStyle: .none,   timeStyle: .short) }

    var fullDateTime: String   { localizedDescription(dateStyle: .full,   timeStyle: .full) }
    var longDateTime: String   { localizedDescription(dateStyle: .long,   timeStyle: .long) }
    var mediumDateTime: String { localizedDescription(dateStyle: .medium, timeStyle: .medium) }
    var shortDateTime: String  { localizedDescription(dateStyle: .short,  timeStyle: .short) }
}
