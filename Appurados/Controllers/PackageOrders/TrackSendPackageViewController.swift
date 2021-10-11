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
    var pickUpmarker = GMSMarker()
    var dropUpMarker = GMSMarker()
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var locationManager: CLLocationManager!
    var pickLatitude:Double = 0.0
    var pickLongitude:Double = 0.0
    var dropLatitude:Double = 0.0
    var dropLongitude:Double = 0.0
    
    var objPackageDetails:SendPackageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapInitilize()
        // Do any additional setup after loading the view.
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
     
        
        
    }
  

}
