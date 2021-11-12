//
//  OrdersDetailModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 08/09/21.
//

import UIKit

class OrdersDetailModel: NSObject {
    
    var strVendorID: String = ""
    var strBannerImage: String = ""
    var strVendorName:String = ""
    var strRastaurentImg :String = ""
    var strDiscountLabel:String = ""
    var strTimeAgo:String = ""
    var strPrice:String = ""
    var strDeliveryCharge:String = ""
    var strSubTotal:String = ""
    var strOrderID:String = ""
    
    var pickLat:Double = 0.0
    var pickLong:Double = 0.0
    var dropLat:Double = 0.0
    var dropLong:Double = 0.0
    var driverLat:Double = 0.0
    var driveLong:Double = 0.0
    
    var status:String = ""
    var strEstimateTime:String = ""
    
    var strEstimateTimeForTrack:String = ""
    var strDistanceForTrack:String = ""
    
    var arrCart = [OrdersCartDetailModel]()
    
    init(dict : [String:Any]) {
        
        if let vendor_id = dict["vendor_id"] as? String{
            self.strVendorID = vendor_id
        }else if let vendor_id = dict["vendor_id"] as? Int{
            self.strVendorID = "\(vendor_id)"
        }
        
        if let order_id = dict["order_id"] as? String{
            self.strOrderID = order_id
        }else if let order_id = dict["order_id"] as? Int{
            self.strOrderID = "\(order_id)"
        }
        
        
        if let pick_lat = dict["pick_lat"] as? String{
            self.pickLat  = Double(pick_lat) ?? 0.0
        }else if let pick_lat = dict["pick_lat"] as? Int{
            self.pickLat = Double(pick_lat)
        }else if let pick_lat = dict["pick_lat"] as? Double{
            self.pickLat = pick_lat
        }
        
        if let pick_lng = dict["pick_lng"] as? String{
            self.pickLong  = Double(pick_lng) ?? 0.0
        }else if let pick_lng = dict["pick_lng"] as? Int{
            self.pickLong = Double(pick_lng)
        }else if let pick_lng = dict["pick_lng"] as? Double{
            self.pickLong = pick_lng
        }
        
        if let drop_lat = dict["drop_lat"] as? String{
            self.dropLat  = Double(drop_lat) ?? 0.0
        }else if let drop_lat = dict["drop_lat"] as? Int{
            self.dropLat = Double(drop_lat)
        }else if let drop_lat = dict["drop_lat"] as? Double{
            self.dropLat = drop_lat
        }
        
        
        if let drop_lng = dict["drop_lng"] as? String{
            self.dropLong  = Double(drop_lng) ?? 0.0
        }else if let drop_lng = dict["drop_lng"] as? Int{
            self.dropLong = Double(drop_lng)
        }else if let drop_lng = dict["drop_lng"] as? Double{
            self.dropLong = drop_lng
        }
        
        if let driver_lat = dict["driver_lat"] as? String{
            self.driverLat  = Double(driver_lat) ?? 0.0
        }else if let driver_lat = dict["driver_lat"] as? Int{
            self.driverLat = Double(driver_lat)
        }else if let driver_lat = dict["driver_lat"] as? Double{
            self.driverLat = driver_lat
        }
        
        if let driver_lng = dict["driver_lng"] as? String{
            self.driveLong  = Double(driver_lng) ?? 0.0
        }else if let driver_lng = dict["driver_lng"] as? Int{
            self.driveLong = Double(driver_lng)
        }else if let driver_lng = dict["driver_lng"] as? Double{
            self.driveLong = driver_lng
        }
        
        
        if let banner_image = dict["user_image"] as? String{
            self.strBannerImage = banner_image
        }
        
        
        if let logo = dict["vendor_image"] as? String{
            self.strRastaurentImg = logo
        }
        
        if let status = dict["status"] as? String{
            self.status = status
        }
        
        if let discount = dict["discount"] as? String{
            self.strDiscountLabel = discount
        }
     
        if let vendor_name = dict["vendor_name"] as? String{
            self.strVendorName = vendor_name
        }
        
        if let txn_amount = dict["txn_amount"] as? String{
            self.strPrice = txn_amount
        }
        
        if let delivery_charge = dict["delivery_charge"] as? String{
            self.strDeliveryCharge = delivery_charge
        }
        
        if let sub_total = dict["sub_total"] as? String{
            self.strSubTotal = sub_total
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeAgo = time_ago
        }
        
        if let time = dict["time"] as? String{
            self.strEstimateTime = time
        }
        
        if let estimated_time = dict["estimated_time"] as? String{
            self.strEstimateTimeForTrack = estimated_time
        }
        
        if let distance = dict["distance"] as? String{
            self.strDistanceForTrack = distance
        }
        
        if let arrCatrItems = dict["cart"] as? [[String:Any]]{
            for data in arrCatrItems{
                let obj = OrdersCartDetailModel(dict: data)
                self.arrCart.append(obj)
            }
        }
        
        
        
        
        
    }

}


class OrdersCartDetailModel: NSObject {
    
    var strCartAmount: String = ""
    var strCartItemImage: String = ""
    var strCartProductName:String = ""
    
    init(dict : [String:Any]) {
        
        if let amount = dict["amount"] as? String{
            self.strCartAmount = amount
        }else if let amount = dict["amount"] as? Int{
            self.strCartAmount = "\(amount)"
        }
        
        if let image = dict["image"] as? String{
            self.strCartItemImage = image
        }
        
        if let product_name = dict["product_name"] as? String{
            self.strCartProductName = product_name
        }
        
    }
    
}


/*
 {
     address = "Vijay Nagar";
     "admin_amt" = "29601.6";
     "admin_settled" = 1;
     "cancel_by" = 0;
     cart =     (
                 {
             "addon_items" = "";
             amount = 6;
             entrydt = "2021-08-10 10:13:34";
             image = "https://ambitious.in.net/Arun/appurados/uploads/product/53261PATACON CON ROPA VIEJA (DESTACADOS).jpg";
             "order_cart_id" = 14;
             "order_id" = 7;
             price = 6;
             "product_id" = 471;
             "product_name" = "Patac\U00f3n con ropa vieja";
             "product_price" = "6.0";
             quantity = 1;
             status = 1;
             "user_id" = 2;
             "variant_name" = "";
             "vendor_id" = 32;
         }
     );
     date = "0000-00-00";
     datetime = "2021-08-10 15:43:34";
     "delivery_charge" = "29600.32";
     discount = 0;
     "display_address" = Carrasquilla;
     distance = "15583.12";
     "driver_lat" = "<null>";
     "driver_lng" = "<null>";
     "drop_address" = "Vijay Nagar";
     "drop_lat" = "22.7532848";
     "drop_lng" = "75.8936962";
     entrydt = "2021-08-10 10:13:34";
     instractions = "";
     "order_id" = 7;
     otp = 6654;
     "package_delivery_id" = 0;
     "payment_mode" = Online;
     "pick_address" = "av 1 sur carrasquilla panama ";
     "pick_lat" = "8.9997192";
     "pick_lng" = "-79.5155032";
     promocode = "";
     reviewed = 0;
     "rider_amt" = 0;
     "rider_id" = 0;
     "rider_image" = "https://ambitious.in.net/Arun/appurados/";
     "rider_mobile" = "<null>";
     "rider_name" = "<null>";
     "rider_settled" = 0;
     speed = 40;
     status = pending;
     "sub_total" = 6;
     time = "389.57 Hrs";
     "time_ago" = "4 weeks ago";
     "txn_amount" = "29606.3";
     "txn_id" = "";
     "user_id" = 2;
     "user_image" = "https://ambitious.in.net/Arun/appurados/uploads/user/7454f48ca380efe63151cc478aee8f01.jpg";
     "user_mobile" = 8839902727;
     "user_name" = "Arun Goswami";
     "vendor_amt" = "4.68";
     "vendor_id" = 32;
     "vendor_image" = "https://ambitious.in.net/Arun/appurados/uploads/user/4433MISIA CHANA.jpg";
     "vendor_mobile" = 0050763159320;
     "vendor_name" = "Misia Chana ";
     "vendor_settled" = 0;
 }
 )
 */
