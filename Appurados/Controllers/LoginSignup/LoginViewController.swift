//
//  LoginViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfEmail.text = "arun@gmail.com"
        self.tfPassword.text = "12345"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnLogin(_ sender: Any) {
        self.validateForLogin()
       // self.pushVc(viewConterlerId: "MapViewController")
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//        let navController = UINavigationController(rootViewController: vc)
//        navController.isNavigationBarHidden = true
//        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func btnGoToSignUp(_ sender: Any) {
        pushVc(viewConterlerId: "SignUpViewController")
    }
    
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    

}


extension LoginViewController{
    
    //MARK:- All Validations
    func validateForLogin(){
        self.view.endEditing(true)
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsLogin()
        }
    }
}



//MARK:- Call Webservice
extension LoginViewController{
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "type":"user",
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {

                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                        objAppShareData.fetchUserInfoFromAppshareData()
                        self.pushVc(viewConterlerId: "MapViewController")
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
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
