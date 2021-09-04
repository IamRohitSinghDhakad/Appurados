//
//  ForgotPasswordViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 02/09/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        
        self.tfEmail.text = self.tfEmail.text?.trim()
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else{
            self.call_WsForgotPassword()
        }
        
       
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- Call Webservice API
extension ForgotPasswordViewController{
    
    func call_WsForgotPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!,
                         "type":"user"]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_forgotPassword, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
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
                
                objAlert.showAlertCallBack(alertLeftBtn: "Success", alertRightBtn: "OK", title: "Alert", message: message ?? "Your request sent succesfully.", controller: self) {
                    self.onBackPressed()
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
