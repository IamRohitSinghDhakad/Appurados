//
//  OrderBillViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/11/21.
//

import UIKit
import SDWebImage

class OrderBillViewController: UIViewController {
    
    
    @IBOutlet var imgVwuser: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblBasketTotal: UILabel!
    @IBOutlet var lblDeliveryCharge: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    
    var objOrderDetailModel:OrdersDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblBasketTotal.text = "$" + objOrderDetailModel!.strPrice
        self.lblDeliveryCharge.text = "$" + objOrderDetailModel!.strDeliveryCharge
        self.lblDiscount.text = "$" + objOrderDetailModel!.strDiscountLabel
        self.lblTotalAmount.text = "$" + objOrderDetailModel!.strSubTotal
        self.lblName.text = objOrderDetailModel?.strVendorName
        self.lblCategory.text = objOrderDetailModel?.strTimeAgo
        
        let profilePic = objOrderDetailModel?.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                self.imgVwuser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }

        
    }

 
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnGiveRating(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController")as! RatingViewController
        vc.objOrderDetailModel = self.objOrderDetailModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
