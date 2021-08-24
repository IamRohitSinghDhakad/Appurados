//
//  ViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 23/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var vwContaineLogo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwContaineLogo.frame = CGRect(x: self.vwContaineLogo.frame.origin.x, y: UIScreen.main.bounds.size.height/2, width: self.vwContaineLogo.frame.size.width, height: self.vwContaineLogo.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Up()
    }
    
    //MARK: - Animation Methods
    
    func Up()  {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.vwContaineLogo.frame = CGRect(x: self.vwContaineLogo.frame.origin.x, y: 0, width: self.vwContaineLogo.frame.size.width, height: self.vwContaineLogo.frame.size.height)
          //  self.imgVwAnimation.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        }) { (finished) in
            if finished {
              //  self.vwContaineLogo.tilt()
                // Repeat animation to bottom to top
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                   self.goToNextController()
                }
            }
        }

    }


    //MARK: - Redirection Methods
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
        else {
            let vc = (self.authStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
    }
    
}

