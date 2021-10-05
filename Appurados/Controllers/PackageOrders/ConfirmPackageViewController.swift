//
//  ConfirmPackageViewController.swift
//  Appurados
//
//  Created by Rohit Dhakad on 05/10/21.
//

import UIKit
import GoogleMaps

class ConfirmPackageViewController: UIViewController, GMSMapViewDelegate {

    
    @IBOutlet weak var mapVw: GMSMapView!
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
    
    var dictPackageData = [String:Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.dictPackageData)
        self.mapVw.delegate = self
        mapInitilize()
        
        // Do any additional setup after loading the view.
    }
    
    func mapInitilize(){
        
        
        let pickLatitude:Double = Double(self.dictPackageData["pickLatitude"]as? Double ?? 0.0)
        let pickLongitude:Double = Double(self.dictPackageData["pickLongitude"]as? Double ?? 0.0)
        let dropLatitude:Double = Double(self.dictPackageData["receiverLatitude"]as? Double ?? 0.0)
        let dropLongitude:Double = Double(self.dictPackageData["receiverLongitude"]as? Double ?? 0.0)
    

        self.pickUpmarker.map = nil
        self.pickUpmarker.position = CLLocationCoordinate2D(latitude: pickLatitude, longitude: pickLongitude)
        self.pickUpmarker.title = "Pick location"
        //  marker.snippet = "Australia"
        self.pickUpmarker.map = self.mapView
        
//        let zoomLevel = 15.0
//        let camera = GMSCameraPosition.camera(withLatitude: pickLatitude,
//                                              longitude: pickLongitude,
//                                              zoom: Float(zoomLevel))
        
        
        self.dropUpMarker.map = nil
        self.dropUpMarker.position = CLLocationCoordinate2D(latitude: dropLatitude, longitude: dropLongitude)
        self.dropUpMarker.title = "Drop location"
        //  marker.snippet = "Australia"
        self.dropUpMarker.map = self.mapView
        
//        let zoomLevelp = 15.0
//        let camera2 = GMSCameraPosition.camera(withLatitude: dropLatitude,
//                                              longitude: dropLongitude,
//                                              zoom: Float(zoomLevelp))
        
        let camera = GMSCameraPosition.camera(withLatitude: pickLatitude, longitude: pickLongitude, zoom: 16)
        self.mapView?.camera = camera
        self.mapView?.animate(to: camera)
        
        self.mapVw.animate(to: camera)
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaymentTypeOnline(_ sender: Any) {
        
    }
    
    @IBAction func btnPaymentTypeCash(_ sender: Any) {
        
    }
    
    @IBAction func btnNext(_ sender: Any) {
        
    }
}
