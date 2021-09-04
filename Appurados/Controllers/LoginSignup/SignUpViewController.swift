//
//  SignUpViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet var tfFirstName: UITextField!
    @IBOutlet var tfLastName: UITextField!
    @IBOutlet var tfEmailAddress: UITextField!
    @IBOutlet var tfmobileNumber: UITextField!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnPassword: UITextField!
    @IBOutlet var btnReferalCode: UITextField!
    
    var strGender = ""
    var strType = "user"
    var strRegisterId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.strGender = "Male"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnSubmit(_ sender: Any) {
    // onBackPressed()
        self.call_WsSignUp()
    }
    
    @IBAction func btnMale(_ sender: Any) {
        self.strGender = "Male"
    }
    
    @IBAction func btnFemale(_ sender: Any) {
        self.strGender = "FeMale"
    }
    
    
    
    
}

//MARK:- Call Webservice API
extension SignUpViewController{
    
    func call_WsSignUp(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["name": self.tfFirstName.text! + self.tfLastName.text!,
                         "email": self.tfEmailAddress.text!,
                         "mobile": self.tfmobileNumber.text!,
                         "sex": self.strGender,
                         "type":self.strType,
                         "password": self.btnPassword.text!,
                         "refer_by": self.btnReferalCode.text!,
                         "ios_register_id": self.strRegisterId] as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SignUp, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            
            objWebServiceManager.hideIndicator()
            
            var statusCode = Int()
            if let status = (response["status"] as? Int){
                statusCode = status
            }else  if let status = (response["status"] as? String){
                statusCode = Int(status)!
            }
            
            let message = (response["message"] as? String)
            print(response)
            if statusCode == MessageConstant.k_StatusCode{
                objWebServiceManager.hideIndicator()
                if let user_details  = response["result"] as? [String:Any] {

                        print(user_details)
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                        objAppShareData.fetchUserInfoFromAppshareData()
                        self.pushVc(viewConterlerId: "MapViewController")

                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
        
        
    }
    
}
