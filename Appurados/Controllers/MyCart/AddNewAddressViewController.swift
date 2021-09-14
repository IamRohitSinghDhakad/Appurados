//
//  AddNewAddressViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 10/09/21.
//

import UIKit
import MapKit
import CoreLocation
import LocationPicker

class AddNewAddressViewController: UIViewController {

    var strAddressType = ""
    @IBOutlet weak var tfSelectAddress: UITextField!
    @IBOutlet weak var tfLatitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    @IBOutlet weak var tfLandMark: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var imgVwHome: UIImageView!
    @IBOutlet weak var imgVwOffice: UIImageView!
    @IBOutlet weak var imgVwOther: UIImageView!
    
    
    var location: Location? {
        didSet {
            tfSelectAddress.text = location.flatMap({ $0.title }) ?? "No location selected"
            let cordinate = location.flatMap({ $0.coordinate })
            if cordinate != nil{
                self.tfLatitude.text! = "\(cordinate?.latitude ?? 0.0)"
                self.tfLongitude.text! = "\(cordinate?.longitude ?? 0.0)"
            }
           
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwHome.image = #imageLiteral(resourceName: "red")
        self.strAddressType = "Home"
        location = nil
        self.tfSelectAddress.isUserInteractionEnabled = false
        self.tfLatitude.isUserInteractionEnabled = false
        self.tfLongitude.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func clearSelectedState(){
        self.imgVwHome.image = #imageLiteral(resourceName: "radio")
        self.imgVwOther.image = #imageLiteral(resourceName: "radio")
        self.imgVwOffice.image = #imageLiteral(resourceName: "radio")
    }
    
    @IBAction func btnAddressTypeSelect(_ sender: UIButton) {
        self.clearSelectedState()
        switch sender.tag {
        case 0:
            self.strAddressType = "Home"
            self.imgVwHome.image = #imageLiteral(resourceName: "red")
        case 1:
            self.strAddressType = "Office"
            self.imgVwOffice.image = #imageLiteral(resourceName: "red")
        default:
            self.strAddressType = "Other"
            self.imgVwOther.image = #imageLiteral(resourceName: "red")
        }
    }
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnOpenPlacePicker(_ sender: Any) {
       // self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let locationPicker = LocationPickerViewController()
        locationPicker.location = location
        locationPicker.mapType = .standard
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        
        locationPicker.completion = { self.location = $0 }
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func btnSaveAddress(_ sender: Any) {
        self.validateForLogin()
    }
    
    
}



extension AddNewAddressViewController{
    
    //MARK:- All Validations
    func validateForLogin(){
        self.view.endEditing(true)
        self.tfName.text = self.tfName.text!.trim()
        self.tfSelectAddress.text = self.tfSelectAddress.text!.trim()
        self.tfLandMark.text = self.tfLandMark.text!.trim()
        self.tfLatitude.text = self.tfLatitude.text!.trim()
        self.tfLongitude.text = self.tfLongitude.text!.trim()
        
        if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter address name", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfSelectAddress.text?.isEmpty)! {
            objAlert.showAlert(message: "Please select address", title:MessageConstant.k_AlertTitle, controller: self)
        } else if (tfLandMark.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter address landmark", title:MessageConstant.k_AlertTitle, controller: self)
        } else if (tfLatitude.text?.isEmpty)! {
            objAlert.showAlert(message: "latitude not found", title:MessageConstant.k_AlertTitle, controller: self)
        } else if (tfLongitude.text?.isEmpty)! {
            objAlert.showAlert(message: "longitude not found", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsAddNewAddress()
        }
    }
}



//MARK:- Call Webservice
extension AddNewAddressViewController{
    
    func call_WsAddNewAddress(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "address_name":self.strAddressType,
                         "address":self.tfSelectAddress.text!,
                         "landmark":self.tfLandMark.text!,
                         "lat":self.tfLatitude.text!,
                         "lng":self.tfLongitude.text!]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddAddress, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Address save succesfully!", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
               
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
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
