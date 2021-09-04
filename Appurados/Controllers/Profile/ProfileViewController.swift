//
//  ProfileViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfMobileNumber: UITextField!
    @IBOutlet var imgVwFemale: UIImageView!
    @IBOutlet var imgVwMale: UIImageView!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnMale(_ sender: Any) {
    }
    
    @IBAction func btnOnFemale(_ sender: Any) {
        
    }
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnSave(_ sender: Any) {
        
    }
    
}


extension ProfileViewController{
    
    func call_WsGetProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
       // objWebServiceManager.showIndicator()
        
        let dict = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getProfile, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
//                if let user_data  = response["result"] as? [String:Any]{
//
//                    if let name = user_data["name"]as? String{
//                        self.tfUserName.text = name
//                    }
//
//                    if let email = user_data["email"]as? String{
//                        self.tfEmail.text = email
//                    }
//
//                    if let phone = user_data["mobile"]as? String{
//                        self.tfPhone.text = phone
//                    }
//
//                    if let user_image = user_data["user_image"]as? String{
//                        let profilePic = user_image
//                        if profilePic != "" {
//                            let url = URL(string: profilePic)
//                            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "male"))
//                        }
//                    }
//
//                }
//                else {
//                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
//                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
