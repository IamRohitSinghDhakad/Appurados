//
//  MapViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var lblCurrentLocation: UILabel!
    @IBOutlet weak var mapVwGM: GMSMapView!
    
    private var locationMarker: GMSMarker?
    private let locationManager = CLLocationManager()
    
    var currentLocationStr = "Current location"
    
    
    override func viewDidLoad() {
      super.viewDidLoad()

       // self.mapVwGM.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapVwGM = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapVwGM
        
        guard CLLocationManager.locationServicesEnabled() else {
          print("Please enable location services")
          return
        }

        if CLLocationManager.authorizationStatus() == .denied {
          print("Please authorize location services")
          return
        }

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.startUpdatingLocation()
        
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
           // determineCurrentLocation()
    }
    
    
    @IBAction func btnConfrmLocation(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    
}


extension MapViewController: CLLocationManagerDelegate {
    
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if CLLocationManager.authorizationStatus() == .denied {
      print("Please authorize location services")
      return
    }
    print("Unable to get current location. Error: \(error.localizedDescription)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    if let existingMaker = locationMarker {
      CATransaction.begin()
      CATransaction.setAnimationDuration(2.0)
      existingMaker.position = location.coordinate
      CATransaction.commit()
    } else {
        
//      let marker = GMSMarker(position: location.coordinate)
//      // Animated walker images derived from an www.angryanimator.com tutorial.
//      // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
//      let animationFrames = (1...8).compactMap {
//        UIImage(named: "step\($0)")
//      }
//      marker.icon = UIImage.animatedImage(with: animationFrames, duration: 0.8)
//      // Taking into account walker's shadow.
//      marker.groundAnchor = CGPoint(x: 0.5, y: 0.97)
//      marker.map = mapVw
//      locationMarker = marker
    }
   // mapVw.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: 17))
  }
}




//
//extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
//
//    //MARK:- CLLocationManagerDelegate Methods
//
////      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////          let mUserLocation:CLLocation = locations[0] as CLLocation
////
////          let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
////          let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
////
////        self.mapVw.setRegion(mRegion, animated: true)
////      }
//
//  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//          print("Error - locationManager: \(error.localizedDescription)")
//      }
//  //MARK:- Intance Methods
//
//  func determineCurrentLocation() {
//      locationManager = CLLocationManager()
//      locationManager.delegate = self
//      locationManager.desiredAccuracy = kCLLocationAccuracyBest
//      locationManager.requestAlwaysAuthorization()
//
//      if CLLocationManager.locationServicesEnabled() {
//          locationManager.startUpdatingLocation()
//      }
//   }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let mUserLocation:CLLocation = locations[0] as CLLocation
//        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
//        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.mapVw.setRegion(mRegion, animated: true)
//
//        // Get user's Current Location and Drop a pin
//    let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
//        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
//        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
//        self.mapVw.addAnnotation(mkAnnotation)
//    }
//    //MARK:- Intance Methods
//
//    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
//
//        geoCoder.reverseGeocodeLocation(location) {
//            (placemarks, error) -> Void in
//
//            if let mPlacemark = placemarks{
//                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
//                    if let Name = dict["Name"] as? String{
//                        if let City = dict["City"] as? String{
//                            self.currentLocationStr = Name + ", " + City
//                            self.lblCurrentLocation.text = self.currentLocationStr
//                        }
//                    }
//                }
//            }
//        }
//        return currentLocationStr
//    }
//
////    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
////          mapView.animate(toLocation: marker.position)
////          return true
////     }
//}
