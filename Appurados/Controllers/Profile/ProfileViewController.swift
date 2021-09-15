//
//  ProfileViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit
import SDWebImage
import AVKit
import Photos

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
    @IBOutlet var vwPassword: UIView!
    
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var strGender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnMale(_ sender: Any) {
        self.strGender = "Male"
        self.imgVwMale.image = #imageLiteral(resourceName: "red")
        self.imgVwFemale.image = #imageLiteral(resourceName: "radio")
    }
    
    @IBAction func btnOnFemale(_ sender: Any) {
        self.strGender = "Female"
        self.imgVwMale.image = #imageLiteral(resourceName: "radio")
        self.imgVwFemale.image = #imageLiteral(resourceName: "red")
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnSave(_ sender: Any) {
        self.call_wsUpdateProfile()
    }
    
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
}

extension ProfileViewController{
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            DispatchQueue.main.async {
                self.showCameraAlert()
            }
            
        case .restricted:
            print("Restricted, device owner must approve")
            DispatchQueue.main.async {
                self.showCameraAlert()
            }
        case .authorized:
            print("Authorized, proceed")
            DispatchQueue.main.async {
                self.openCamera()
              //  self.setImage()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        self.openCamera()
                     //   self.setImage()
                    }
                } else {
                    print("Permission denied")
                    DispatchQueue.main.async {
                        self.showCameraAlert()
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    
    //MARK: - Photo Library Permission
    
    func openPhotoLibraryPermissions() {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .authorized) {
            // Access has been granted.
            DispatchQueue.main.async {
                self.openGallery()
            }
        } else if (status == .denied) {
            // Access has been denied.
            DispatchQueue.main.async {
                self.presentPhotoLibrarySettings()
            }
        } else if (status == .restricted) {
            // Access has been restricted.
            DispatchQueue.main.async {
                self.presentPhotoLibrarySettings()
            }
        } else if (status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.openGallery()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentPhotoLibrarySettings()
                    }
                }
            })
        }
    }
    
    func presentPhotoLibrarySettings() {
        let uiAlert = UIAlertController(title: "Alert", message: "In order to capture images you have to allow camera under your settings.", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
    }
    
    func showCameraAlert(){
        let uiAlert = UIAlertController(title: "Alert", message: "In order to capture images you have to allow camera under your settings.", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
    }
}

//Image Piker Delegates
extension ProfileViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK:- UIImage Picker Delegate
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.checkCameraAccess()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openPhotoLibraryPermissions()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
           self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgVwUser.image = self.pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
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

                    if let isSocialType = user_data["social_type"]as? String{
                        if isSocialType == ""{
                            self.vwPassword.isHidden = false
                        }else{
                            self.vwPassword.isHidden = true
                        }
                        
                    }else{
                        self.vwPassword.isHidden = false
                    }
                    
                    if let name = user_data["name"]as? String{
                        self.tfName.text = name
                        self.lblName.text = name
                    }

                    if let email = user_data["email"]as? String{
                        self.tfEmail.text = email
                        self.lblEmail.text = email
                    }

                    if let phone = user_data["mobile"]as? String{
                        self.tfMobileNumber.text = phone
                    }
                    
                    if let pswrd = user_data["password"]as? String{
                        self.tfPassword.text = pswrd
                    }
                   
                    if let gender = user_data["sex"]as? String{
                        self.strGender = gender
                    }else{
                        self.strGender = "Male"
                    }
                    
                    if self.strGender == "Male"{
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
       
        let dicrParam = [ "user_id":objAppShareData.UserDetail.strUserId,
                          "name":self.tfName.text!,
                          "email":self.tfEmail.text!,
                          "sex":self.strGender,
                          "password":self.tfPassword.text!,
                          "mobile":self.tfMobileNumber.text!]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_updateProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                self.call_WsGetProfile()

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
}
