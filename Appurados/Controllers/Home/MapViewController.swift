//
//  MapViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
//import CoreLocation
import GooglePlaces
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet var lblCurrentLocation: UILabel!
    @IBOutlet var vwMap: UIView!
    @IBOutlet var btnOpenSearch: UIButton!
    var cirlce: GMSCircle!
    var userSelectedLatitude : Double?
    var userSelectedLongitude : Double?
    var currentLocationStr = "Current location"
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    private var locationMarker: GMSMarker?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: self.vwMap.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
       
        mapView.delegate = self
        // Add the map to the view, hide it until we've got a location update.
        self.vwMap.addSubview(mapView)
        mapView.isHidden = false
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
           // determineCurrentLocation()
        let defaultLocation = CLLocation(latitude: 19.017615, longitude: 72.856164)
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        cirlce = GMSCircle(position: camera.target, radius: 100)
        cirlce.fillColor = UIColor.red.withAlphaComponent(0.5)
        cirlce.map = mapView
    }
    
    @IBAction func btnOpenSearch(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
           placePickerController.delegate = self
           present(placePickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnConfrmLocation(_ sender: Any) {
        objAppShareData.UserDetail.strlatitude = "\(String(describing: self.userSelectedLatitude))"
        objAppShareData.UserDetail.strlongitude = "\(String(describing: self.userSelectedLongitude))"
        objAppShareData.UserDetail.strAddress = self.lblCurrentLocation.text ?? "Something went wrong!"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    
}

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

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

//    listLikelyPlaces()
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
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
      //  print(marker)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
          // print("\(position.target.latitude) \(position.target.longitude)")
        
        let myLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        var strFinalAddress = ""

      //  print(myLocation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            myLocation.fetchAddress { address, error in
                guard let address = address, error == nil else
                {return}
                strFinalAddress = address
                self.userSelectedLatitude = position.target.latitude
                self.userSelectedLongitude = position.target.longitude
                self.lblCurrentLocation.text = strFinalAddress
            }
        }
      

        if cirlce != nil{
            cirlce.position = position.target
            self.lblCurrentLocation.text = strFinalAddress
        }
       }
    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        // Creates a marker in the center of the map.
//
//
////        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
////        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
////                                              longitude: coordinate.longitude,
////                                              zoom: zoomLevel)
////
////        if mapView.isHidden {
////          mapView.isHidden = false
////          mapView.camera = camera
////        } else {
////          mapView.animate(to: camera)
////        }
//        mapView.clear()
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.latitude)
//        marker.icon = #imageLiteral(resourceName: "red_marker")
//        marker.appearAnimation = .pop
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        DispatchQueue.main.async {
//            marker.map = self.mapView
//        }
//
//    }
}

/*
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
    
   // let location = locations.last

    let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
    
    self.mapVwGM?.animate(to: camera)
    
    //Finally stop updating location otherwise it will come again and again in this delegate
   // self.locationManager.stopUpdatingLocation()
    
//    if let existingMaker = locationMarker {
//      CATransaction.begin()
//      CATransaction.setAnimationDuration(2.0)
//      existingMaker.position = location.coordinate
//      CATransaction.commit()
//    } else {
//
//      let marker = GMSMarker(position: location.coordinate)
//      // Animated walker images derived from an www.angryanimator.com tutorial.
//      // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
//      let animationFrames = (1...8).compactMap {
//        UIImage(named: "step\($0)")
//      }
//        marker.icon = #imageLiteral(resourceName: "red")
//      // Taking into account walker's shadow.
//      marker.groundAnchor = CGPoint(x: 0.5, y: 0.97)
//      marker.map = mapVwGM
//      locationMarker = marker
//    }
//    let camera = try GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.latitude, zoom: 14.0)
//    DispatchQueue.main.async {
//        CATransaction.begin()
//        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
//        self.locationMarker?.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
//        self.locationMarker?.map?.animate(to: camera)
//        CATransaction.commit()
//    }
//
    
//    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
//    mapVwGM.camera = camera
//    mapVwGM.animate(to: camera)
//    mapVwGM.moveCamera(GMSCameraUpdate.setCamera(camera))
//    mapVwGM.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: 17))
  }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        return true
    }
}
*/


extension MapViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(String(describing: place.name))")
    print("Place address: \(String(describing: place.formattedAddress))")
    print("Place attributions: \(String(describing: place.attributions))")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}


extension CLLocation {
func fetchAddress(completion: @escaping (_ address: String?, _ error: Error?) -> ()) {
    CLGeocoder().reverseGeocodeLocation(self) {
        let palcemark = $0?.first
        var address = ""
        if let subThoroughfare = palcemark?.subThoroughfare {
            address = address + subThoroughfare + ","
        }
        if let thoroughfare = palcemark?.thoroughfare {
            address = address + thoroughfare + ","
        }
        if let locality = palcemark?.locality {
            address = address + locality + ","
        }
        if let subLocality = palcemark?.subLocality {
            address = address + subLocality + ","
        }
        if let administrativeArea = palcemark?.administrativeArea {
            address = address + administrativeArea + ","
        }
        if let postalCode = palcemark?.postalCode {
            address = address + postalCode + ","
        }
        if let country = palcemark?.country {
            address = address + country + ","
        }
        if address.last == "," {
            address = String(address.dropLast())
        }
        completion(address,$1)
       // completion("\($0?.first?.subThoroughfare ?? ""), \($0?.first?.thoroughfare ?? ""), \($0?.first?.locality ?? ""), \($0?.first?.subLocality ?? ""), \($0?.first?.administrativeArea ?? ""), \($0?.first?.postalCode ?? ""), \($0?.first?.country ?? "")",$1)
    }
 }
}


extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
