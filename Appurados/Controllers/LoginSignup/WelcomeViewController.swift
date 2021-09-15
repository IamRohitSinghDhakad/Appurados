//
//  WelcomeViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

struct SocialLoginParameter {
    var name: String = ""
    var email: String = ""
    var social_id: String = ""
    var social_type: String = ""
    var register_id: String = ""
    
}

class WelcomeViewController: UIViewController {

    var isAccepted = ""
    let loginManager = LoginManager()
    var isFBLogin : Bool {
        get {
            if let token = AccessToken.current, !token.isExpired {
                // User is logged in, do work such as go to next view controller.
                return true
            }
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func btnOnSkip(_ sender: Any) {
        
    }
    
    @IBAction func btnFacebookLogin(_ sender: Any) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        if let accessToken = AccessToken.current, !accessToken.isExpired {
            // User is logged in, do work such as go to next view controller.
            self.getFBUserDetails()
        }
        else {
            // Access token not available -- user already logged out
            // Perform log in
            loginManager.logIn(permissions: [Permission.publicProfile.name, Permission.email.name], from: self) { (result, error) in
                // Check for error
                guard error == nil else {
                    // Error occurred
                    return
                }
                
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    return
                }
                
                DispatchQueue.main.async {
                    // Successfully logged in
                    print("Result: \(result)\n\nError: \(error)\n\n")
                    self.getFBUserDetails()
                }
            }
        }
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBAction func btnapple(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            //  authorizationController.delegate = self
            // Create an authorization controller with the given requests.
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }

    }
    
    @IBAction func btnOtherWay(_ sender: Any) {
        pushVc(viewConterlerId: "LoginViewController")
    }
}


//MARK: - FB Graph API

extension WelcomeViewController {
    func getFBUserDetails() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name,picture.type(large),gender,birthday"], tokenString: AccessToken.current!.tokenString, version: Settings.graphAPIVersion, httpMethod: .get)
        request.start { (graphRequestConnection, result, error) in
            guard error == nil else {
                // Error occurred
                print("Process error: \(error!.localizedDescription)")
                objAlert.showAlert(message: error!.localizedDescription, title: "Alert", controller: self)
                return
            }
            if let userData = result as? [String:AnyObject] {
                print("User Data: \(userData)")
                if let name = userData["name"] as? String, let email = userData["email"] as? String, let social_id = userData["id"] as? String {
                    let social_type = "fb"
                    let register_id = objAppShareData.strFirebaseToken
                    var socialMediaParam = SocialLoginParameter()
                    socialMediaParam.name = name
                    socialMediaParam.email = email
                    socialMediaParam.social_id = social_id
                    socialMediaParam.social_type = social_type
                    socialMediaParam.register_id = register_id
                    self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
                }
                
            }
        }
    }
}

//MARK: - Google Sign In Delegate

extension WelcomeViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
                objAlert.showAlert(message: "The user has not signed in before or they have since signed out.", title: "Alert", controller: self)
            } else {
                print("\(error.localizedDescription)")
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
            }
            return
        }
        if let userdata = user {
            //            let idToken = userdata.authentication.idToken
            let social_type = "google"
            let register_id = objAppShareData.strFirebaseToken
            var socialMediaParam = SocialLoginParameter()
            socialMediaParam.name = userdata.profile.name
            socialMediaParam.email = userdata.profile.email
            socialMediaParam.social_id = userdata.userID
            socialMediaParam.social_type = social_type
            socialMediaParam.register_id = register_id
            self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
        }
    }
}


//MARK:- Apple login
@available(iOS 13.0, *)
extension WelcomeViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            var socialMediaParam = SocialLoginParameter()
            var firstName = ""
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            _ = appleIDCredential.fullName
            if let email = appleIDCredential.email{
                socialMediaParam.email = email
            }
            if let givenName = appleIDCredential.fullName?.givenName{
                firstName = givenName
            }
            if let familyName = appleIDCredential.fullName?.familyName{
                socialMediaParam.name = firstName + " " + familyName
            }
            
            print(socialMediaParam.email)
            print(socialMediaParam.name)
            print(userIdentifier)
            
            socialMediaParam.social_id = userIdentifier
            socialMediaParam.social_type = "Apple"
            socialMediaParam.register_id = objAppShareData.strFirebaseToken
            
            self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
            
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                // self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
}


//MARK:- Call Webservice
extension WelcomeViewController{
    
    func call_WsSocialLogin(socialMediaParam: SocialLoginParameter){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["name": socialMediaParam.name, "email": socialMediaParam.email, "social_id": socialMediaParam.social_id, "social_type": socialMediaParam.social_type, "ios_register_id": socialMediaParam.register_id] as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SocialLogin, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
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
