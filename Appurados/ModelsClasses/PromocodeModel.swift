//
//  PromocodeModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 13/09/21.
//

import UIKit

class PromocodeModel: NSObject {
    
    var strOrder_cart_id:String = ""
    var strPromocodeImage:String = ""
    var strReceiver_name:String = ""
    var strPurchasedStatus:String = ""
    var strPoints:String = ""
    var strActualPrice:String = ""
    var strPromocode:String = ""
 
    
    init(dict : [String:Any]) {
        
        if let order_cart_id = dict["order_cart_id"] as? String{
            self.strOrder_cart_id = order_cart_id
        }else if let order_cart_id = dict["order_cart_id"] as? Int{
            self.strOrder_cart_id = "\(order_cart_id)"
        }
        
        if let points = dict["points"] as? String{
            self.strPoints = points
        }else if let points = dict["points"] as? Int{
            self.strPoints = "\(points)"
        }
        
        if let price = dict["price"] as? String{
            self.strActualPrice = price
        }else if let price = dict["price"] as? Int{
            self.strActualPrice = "\(price)"
        }
        
        if let purchased = dict["purchased"] as? String{
            self.strPurchasedStatus = purchased
        }else if let purchased = dict["purchased"] as? Int{
            self.strPurchasedStatus = "\(purchased)"
        }
      
        if let promocode_image = dict["promocode_image"] as? String{
            self.strPromocodeImage = promocode_image
        }
        
        if let promocode = dict["promocode"] as? String{
            self.strPromocode = promocode
        }
        
      
    }
    
    

}

/*
 {
     "category_id" = "<null>";
     description = "cash back ";
     "discount_type" = Fixed;
     "discount_value" = 0;
     entrydt = "2021-09-12 17:40:15";
     "min_bill_amt" = 5;
     "offer_type" = "Offer Voucher";
     points = 300;
     promocode = cuponcash10;
     "promocode_id" = 9;
     "promocode_image" = "https://ambitious.in.net/Arun/appurados/uploads/promocode/CASH BACK.png";
     "promocode_title" = "cash back";
     purchased = 0;
     status = 1;
     "valid_from" = "2021-09-11";
     "valid_to" = "2022-01-26";
     "vendor_id" = 0;
     "vendor_name" = "<null>";
 },
 */
