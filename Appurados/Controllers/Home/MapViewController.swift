//
//  MapViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var lblCurrentLocation: UILabel!
    @IBOutlet weak var mapVwGM: GMSMapView!
    @IBOutlet var vwMap: UIView!
    @IBOutlet var btnOpenSearch: UIButton!
    
    
    private var locationMarker: GMSMarker?
    private let locationManager = CLLocationManager()
    
    var currentLocationStr = "Current location"
    
    
    override func viewDidLoad() {
      super.viewDidLoad()

       // self.mapVwGM.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 19.017615, longitude: 72.856164, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.vwMap.frame, camera: camera)
        self.mapVwGM = mapView
        self.mapVwGM.delegate = self
        self.mapVwGM.isMyLocationEnabled = true// = CLLocation(latitude: 19.017615, longitude: 72.856164)
        self.mapVwGM.settings.myLocationButton = true
        self.mapVwGM.settings.compassButton = true
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapVwGM
        
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
    
    @IBAction func btnOpenSearch(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
           placePickerController.delegate = self
           present(placePickerController, animated: true, completion: nil)
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
