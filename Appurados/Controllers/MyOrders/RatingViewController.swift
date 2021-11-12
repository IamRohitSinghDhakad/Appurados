//
//  RatingViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/11/21.
//

import UIKit
import SDWebImage

class RatingViewController: UIViewController,FloatRatingViewDelegate {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblVendorName: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var vwFloatRatingVw: FloatRatingView!
    @IBOutlet var txtVwComment: RDTextView!
    
    var ratingValue:Double = 0.0
    
    var objOrderDetailModel:OrdersDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwFloatRatingVw.delegate = self
        self.lblVendorName.text = objOrderDetailModel?.strVendorName
        
        let profilePic = objOrderDetailModel?.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print(rating)
        self.ratingValue = rating
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        
        self.call_WsSubmitRating()
    }
  
}


//MARK:- Call Api
extension RatingViewController{
    
    //MARK:- Vendor Count Product
    func call_WsSubmitRating(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":objOrderDetailModel!.strVendorID,
                         "order_id":objOrderDetailModel!.strOrderID,
                         "rating":"\(ratingValue)",
                         "review":txtVwComment.text ?? ""]as [String:Any]
    print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GiveRating, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { response in
        
        objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

  
                if let arrDict = response["result"]as? [[String:Any]]{
                    
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "success", message: "Rating Submit succesfully", controller: self) {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
                        let navController = UINavigationController(rootViewController: vc)
                        navController.isNavigationBarHidden = true
                        appDelegate.window?.rootViewController = navController
                        
                    }
                    
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
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
