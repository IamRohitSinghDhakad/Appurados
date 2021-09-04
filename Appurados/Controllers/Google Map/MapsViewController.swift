//
//  GoogleMapViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 04/09/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapsViewController: UIViewController {

    @IBOutlet weak var mapVw: GMSMapView!
    
    private var locationMarker: GMSMarker?
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapVw = GMSMapView.map(withFrame: self.view.frame, camera: camera)
       // mapVw.delegate = self
     //   self.view.addSubview(mapVw)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapVw
        
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

}

extension MapsViewController: CLLocationManagerDelegate {
    
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
        
      let marker = GMSMarker(position: location.coordinate)
      // Animated walker images derived from an www.angryanimator.com tutorial.
      // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
      let animationFrames = (1...8).compactMap {
        UIImage(named: "step\($0)")
      }
      marker.icon = UIImage.animatedImage(with: animationFrames, duration: 0.8)
      // Taking into account walker's shadow.
      marker.groundAnchor = CGPoint(x: 0.5, y: 0.97)
      marker.map = mapVw
      locationMarker = marker
    }
    mapVw.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: 17))
  }
}
