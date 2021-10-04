//
//  SendPackageDropOffViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 03/10/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SendPackageDropOffViewController: UIViewController {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tfLandMark: UITextField!
    @IBOutlet weak var mapVw: UIView!
    
    var userSelectedLatitude : Double?
    var userSelectedLongitude : Double?
    var currentLocationStr = "Current location"
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var marker = GMSMarker()
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
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
        
        placesClient = GMSPlacesClient.shared()
        
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
    
    @IBAction func btnOnNext(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPackagePickUpViewController")as! SendPackagePickUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOpenaddressPicker(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
           placePickerController.delegate = self
           present(placePickerController, animated: true, completion: nil)
    }
    
}


// Delegates to handle events for the location manager.
extension SendPackageDropOffViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        
        
        marker.map = nil
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = "My location"
        //  marker.snippet = "Australia"
        marker.map = mapView
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        
        var strFinalAddress = ""
        let myLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        myLocation.fetchAddress { address, error in
            guard let address = address, error == nil else
            {return}
            strFinalAddress = address
            self.userSelectedLatitude = location.coordinate.latitude
            self.userSelectedLongitude = location.coordinate.longitude
            self.lblAddress.text = strFinalAddress
        }
        
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

extension SendPackageDropOffViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        //  print(marker)
        var strFinalAddress = ""
        let myLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        myLocation.fetchAddress { address, error in
            guard let address = address, error == nil else
            {return}
            strFinalAddress = address
            self.userSelectedLatitude = marker.position.latitude
            self.userSelectedLongitude = marker.position.longitude
            self.lblAddress.text = strFinalAddress
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // print("\(position.target.latitude) \(position.target.longitude)")
        
        //        let myLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        //        var strFinalAddress = ""
        // marker.position = position.target
        // self.lblCurrentLocation.text = strFinalAddress
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        
        var strFinalAddress = ""
        let myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            myLocation.fetchAddress { address, error in
                guard let address = address, error == nil else
                {return}
                strFinalAddress = address
                self.userSelectedLatitude = coordinate.latitude
                self.userSelectedLongitude = coordinate.longitude
                self.lblAddress.text = strFinalAddress
            }
        }
        
        
        marker.map = nil
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print(marker.position)
        DispatchQueue.main.async {
            
            self.marker.title = "Selected location"
            //  marker.snippet = "Australia"
            self.marker.map = self.mapView
            let zoomLevel = self.locationManager.accuracyAuthorization == .fullAccuracy ? self.preciseLocationZoomLevel : self.approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                  longitude: coordinate.longitude,
                                                  zoom: zoomLevel)
            mapView.animate(to: camera)
        }
    }
    
}

extension SendPackageDropOffViewController: GMSAutocompleteViewControllerDelegate {
    
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

