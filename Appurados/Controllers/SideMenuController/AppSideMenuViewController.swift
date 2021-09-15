//
//  AppSideMenuViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class SideMenuOptions: Codable {
    var menuName: String = ""
    var menuImageName: String = ""
    var menuSelectedImageName: String = ""
    init(menuName: String, menuImageName: String, menuSelectedImageName: String) {
        self.menuName = menuName
        self.menuImageName = menuImageName
        self.menuSelectedImageName = menuSelectedImageName
    }
}

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class AppSideMenuViewController: UIViewController {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    var selectedIndexpath = 0
    var strBadgeCount = ""
    
    private let menus: [SideMenuOptions] = [SideMenuOptions(menuName: "Home", menuImageName: "home", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Profile", menuImageName: "profile", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "My Cart", menuImageName: "cart", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "My Orders", menuImageName: "list", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Package Orders", menuImageName: "bike", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "My Favorites", menuImageName: "like", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Rewards", menuImageName: "card", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Offers", menuImageName: "tag", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Notification", menuImageName: "notification", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Refer and Earn", menuImageName: "share", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "About Us", menuImageName: "information", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Support", menuImageName: "spoon", menuSelectedImageName: ""),
                                            SideMenuOptions(menuName: "Logout", menuImageName: "logout", menuSelectedImageName: "")]
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        controllerMenuSetup()
    
        sideMenuController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let profilePic = objAppShareData.UserDetail.strProfilePicture .trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user-1"))
            }

    }
    
    private func controllerMenuSetup() {
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController")
        }, with: "2")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController")
        }, with: "3")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SendPackageViewController")
        }, with: "4")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyFavoritesViewController")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyRewardViewController")
        }, with: "6")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyOffersViewController")
        }, with: "7")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")
        }, with: "8")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
        }, with: "10")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SupportViewController")
        }, with: "11")

    }
    
    private func configureView() {
        SideMenuController.preferences.basic.menuWidth = view.frame.width * 0.5
        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let sideMenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sideMenuBasicConfiguration.position == .under) != (sideMenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
}

extension AppSideMenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }
    
    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }
    
    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }
    
    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }
    
    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

extension AppSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSideMenuTableViewCell", for: indexPath) as! AppSideMenuTableViewCell
        let row = indexPath.row
        if self.selectedIndexpath == indexPath.row{
            cell.imgVw.image = UIImage(named: menus[row].menuImageName)
        }else{
            cell.imgVw.image = UIImage(named: menus[row].menuImageName)
        }
                
        
        cell.menuName.text = menus[row].menuName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        self.selectedIndexpath = row
        
//        if objAppShareData.isDemoMode == true{
//            if row == 1{
//
//            }
//        }
        
        switch row {
        case 1:
            if objAppShareData.isDemoMode == true{
                sideMenuController?.hideMenu()
                objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Login Needed", message: "To use this functionality you have to login first\nWant to login now?", controller: self) {
                    //Back to login page
                    AppSharedData.sharedObject().signOut()
                }
                
            }else{
                sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
                sideMenuController?.hideMenu()
                
                if let identifier = sideMenuController?.currentCacheIdentifier() {
                    print("[Example] View Controller Cache Identifier: \(identifier)")
                }
            }
            
        case 9:
            sideMenuController?.hideMenu()
            let text = "This is the text.... Appurados App"
            _ = UIImage(named: "Product")
            let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
            let shareAll = [text, myWebsite!] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        case 12:
            sideMenuController?.hideMenu()
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Logout?", message: "Are you sure you want to logout?", controller: self) {
                AppSharedData.sharedObject().signOut()
            }
        default:
            sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
            
            if let identifier = sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
            }
        }
       
        
//        if row == 9{
//            sideMenuController?.hideMenu()
//
//            let text = "This is the text.... Appurados App"
//            let image = UIImage(named: "Product")
//            let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
//            let shareAll = [text, myWebsite!] as [Any]
//            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            self.present(activityViewController, animated: true, completion: nil)
//        }
//        if row == 12 {
//            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Logout?", message: "Are you sure you want to logout?", controller: self) {
//                AppSharedData.sharedObject().signOut()
//                //self.call_WSLogout(strUserID: objAppShareData.UserDetail.strUserId)
//            }
//
//        }
//        else {
//            sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
//            sideMenuController?.hideMenu()
//
//            if let identifier = sideMenuController?.currentCacheIdentifier() {
//                print("[Example] View Controller Cache Identifier: \(identifier)")
//            }
//        }
        
        self.tableView.reloadData()
    }
}



extension UITableView
{
    func updateRow(row: Int, section: Int = 0)
    {
        let indexPath = IndexPath(row: row, section: section)
        
        self.beginUpdates()
        self.reloadRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
}
