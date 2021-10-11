//
//  SendPackageModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 10/09/21.
//

import UIKit

class SendPackageModel: NSObject {

    var strOffer_category_id:String = ""
    var strUser_image:String = ""
    var strReceiver_name:String = ""
    var strTime_ago:String = ""
    var strAmount:String = ""
    var strStatus:String = ""
    var strDrop_address:String = ""
    var strPick_address:String = ""
    var strEstimateTime:String = ""
    var strDistance:String = ""
    
    init(dict : [String:Any]) {
        
        if let offer_category_id = dict["offer_category_id"] as? String{
            self.strOffer_category_id = offer_category_id
        }else if let offer_category_id = dict["offer_category_id"] as? Int{
            self.strOffer_category_id = "\(offer_category_id)"
        }
        
        if let amount = dict["amount"] as? String{
            self.strAmount = amount
        }else if let amount = dict["amount"] as? Int{
            self.strAmount = "\(amount)"
        }
        
        if let drop_address = dict["drop_address"] as? String{
            self.strDrop_address = drop_address
        }
        
        if let pick_address = dict["pick_address"] as? String{
            self.strPick_address = pick_address
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUser_image = user_image
        }
        
        if let status = dict["status"] as? String{
            self.strStatus = status
        }
        
        if let receiver_name = dict["receiver_name"] as? String{
            self.strReceiver_name = receiver_name
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTime_ago = time_ago
        }
        
        if let estimated_time = dict["estimated_time"] as? String{
            self.strEstimateTime = estimated_time
        }
        
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
    }
    
    
    /*
     {
         amount = "1.9";
         date = "0000-00-00";
         datetime = "2021-08-19 13:37:51";
         distance = "3.46";
         "drop_address" = "Rajiv Gandhi Square, 40, Sarvanand Nagar, Mangal Nagar, Indore, Madhya Pradesh 452001, India";
         "drop_landmark" = test;
         "drop_lat" = "22.68294063489539";
         "drop_lng" = "75.85721980780363";
         entrydt = "2021-08-19 08:07:51";
         "estimated_time" = "0.08 Hrs";
         instruction = "";
         otp = 6648;
         "package_delivery_id" = 18;
         "payment_mode" = Cash;
         "payment_status" = 0;
         "pick_address" = "766, Raj Mohalla Chowk, Anand Nagar, Azad Nagar, Indore, Madhya Pradesh 452001, India";
         "pick_landmark" = ggfg;
         "pick_lat" = "22.700518880327856";
         "pick_lng" = "75.88515870273113";
         "receiver_mobile" = 8877665544;
         "receiver_name" = Arun;
         "rider_id" = 1;
         "rider_image" = "https://ambitious.in.net/Arun/appurados/uploads/user/3301shutterstock_1146895727-1.jpg";
         "rider_lat" = "8.988778";
         "rider_lng" = "-79.5284742";
         "rider_mobile" = 9988776655;
         "rider_name" = "Test Rider";
         "sender_mobile" = 8839902727;
         "sender_name" = "Arun Goswami";
         status = Complete;
         "time_ago" = "3 weeks ago";
         updatedt = "2021-09-07 20:34:01";
         "user_id" = 2;
         "user_image" = "https://ambitious.in.net/Arun/appurados/uploads/user/7454f48ca380efe63151cc478aee8f01.jpg";
         "user_mobile" = 8839902727;
         "user_name" = "Arun Goswami";
     }
     */
}
