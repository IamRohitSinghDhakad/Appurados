//
//  ProfileViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit
import SDWebImage

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
        self.imgVwMale.image = #imageLiteral(resourceName: "red")
        self.imgVwFemale.image = #imageLiteral(resourceName: "radio")
    }
    
    @IBAction func btnOnFemale(_ sender: Any) {
        self.imgVwMale.image = #imageLiteral(resourceName: "radio")
        self.imgVwFemale.image = #imageLiteral(resourceName: "red")
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
                
                if let user_data  = response["result"] as? [String:Any]{

                    if let name = user_data["name"]as? String{
                        self.tfName.text = name
                    }

                    if let email = user_data["email"]as? String{
                        self.tfEmail.text = email
                    }

                    if let phone = user_data["mobile"]as? String{
                        self.tfMobileNumber.text = phone
                    }
                    
                    if let pswrd = user_data["password"]as? String{
                        self.tfPassword.text = pswrd
                    }
                    var strGender = ""
                    if let gender = user_data["sex"]as? String{
                        strGender = gender
                    }
                    
                    if strGender == "Male"{
                        self.imgVwMale.image = #imageLiteral(resourceName: "red")
                        self.imgVwFemale.image = #imageLiteral(resourceName: "radio")
                    }else{
                        self.imgVwFemale.image = #imageLiteral(resourceName: "red")
                        self.imgVwMale.image = #imageLiteral(resourceName: "radio")
                    }

                    if let user_image = user_data["user_image"]as? String{
                        let profilePic = user_image
                        if profilePic != "" {
                            let url = URL(string: profilePic)
                            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user-1"))
                        }
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "user-1")
                    }

                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
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
    
    //MARK:- Update Profile Webservice
    func call_wsUpdateProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        else {
            imgData = (self.imgVwUser.image?.jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["user_image"]
        
        print(imageData)
        
       
        let dicrParam = ["name":self.tfName.text!,
                         "email":self.tfEmail.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "looking_for":lookingFor,
                         "dob":self.tfDOB.text!,
                         "age":self.strAge,
                         "country":self.tfCountry.text!,
                         "state":self.tfState.text!,
                         "city":self.tfCity.text!,
                         "sex":self.selectedGender,
                         "short_bio":self.txtVwAboutMe.text!,
                         "hair":self.tfHairColor.text!,
                         "eye":self.tfEyeColor.text!,
                         "skin":self.tfSkinTone.text!,
                         "height":self.tfHeightInMeter.text!,
                         "music":self.tfMusic.text!,
                         "sport":self.tfTheSportOf.text!,
                         "cinema":self.tfCinema.text!,
                         "highlight_info":self.txtVwSpecificInformation.text!,
                         "allow_sex":strSelectedIWantToBeFound,
                         "allow_country":self.strSelectedIWantToBeFoundInCountry,
                         "allow_state":self.strSelectedIWantToBeFoundInState,
                         "allow_city":self.strSelectedIWantToBeFoundInCity]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_completeProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()

                if self.isComingFrom == "Basic Information"{
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "Actualización de información básica con éxito", controller: self) {
                        self.onBackPressed()
                    }
                }else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
                    let navController = UINavigationController(rootViewController: vc)
                    navController.isNavigationBarHidden = true
                    appDelegate.window?.rootViewController = navController
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
}
