//
//  AppDelegate.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 23/08/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn

let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate
@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    var googleApiKey = "AIzaSyAkLPzABgs6MROKj2TOsWpPqocmmjUNDvc"
    var googleSignInID = "436121379274-pc9ebpo4d8s7etivu8o81vi59qgdbehu.apps.googleusercontent.com"
     
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //2
        GMSPlacesClient.provideAPIKey("AIzaSyAkLPzABgs6MROKj2TOsWpPqocmmjUNDvc")
        GMSServices.provideAPIKey("AIzaSyAkLPzABgs6MROKj2TOsWpPqocmmjUNDvc")
        
        //3
        GIDSignIn.sharedInstance().clientID = googleSignInID
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    

//    // MARK: UISceneSession Lifecycle
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}


//Manage AutoLogin
extension AppDelegate {
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func HomeNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "Reveal")
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func settingRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //        let navController = UINavigationController(rootViewController: setViewController)
        appDelegate.window?.rootViewController = vc
    }
    
}


public extension UIWindow {
    
    var visibleViewController: UIViewController? {
        
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
        
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        
        if let nc = vc as? UINavigationController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
            
        } else if let tc = vc as? UITabBarController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
            
        } else {
            
            if let pvc = vc?.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
                
            } else {
                
                return vc
                
            }
            
        }
        
    }
    
}
