//
//  RestaurentsDetailModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 05/09/21.
//

import UIKit

class RestaurentsDetailModel: NSObject {

    var strVendorID: String = ""
    var strBannerImage: String = ""
    var strVendorName:String = ""
    var strAddress:String = ""
    var strRastaurentImg :String = ""
    var strDiscountLabel:String = ""
    var strSpecialties:String = ""
    var strDistance:String = ""
    var strTime:String = ""
    var strMinimumOrderAmount:String = ""
    
    init(dict : [String:Any]) {
        
        if let user_id = dict["user_id"] as? String{
            self.strVendorID = user_id
        }else if let user_id = dict["user_id"] as? Int{
            self.strVendorID = "\(user_id)"
        }
        
        if let banner_image = dict["user_image"] as? String{
            self.strBannerImage = banner_image
        }
        
        
        if let logo = dict["logo"] as? String{
            self.strRastaurentImg = logo
        }
        
        if let discount_label = dict["discount_label"] as? String{
            self.strDiscountLabel = discount_label
        }
        
        if let specialties = dict["specialties"] as? String{
            self.strSpecialties = specialties
        }
        
        if let name = dict["name"] as? String{
            self.strVendorName = name
        }
        
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
        
        if let time = dict["time"] as? String{
            self.strTime = time
        }
        
        
        if let min_order_amount = dict["min_order_amount"] as? String{
            self.strMinimumOrderAmount = min_order_amount
        }else if let min_order_amount = dict["min_order_amount"] as? Int{
            self.strMinimumOrderAmount = "\(min_order_amount)"
        }
        
    }
    
    
}

/*
 "account_holder_name" = "Nurangely carroz ";
 "account_no" = 0410999465417;
 address = "calle 57 este obarrio frente al sortis ";
 "bank_name" = "BANCO GENERAL";
 "bonus_given" = 0;
 "branch_name" = "";
 "category_id" = 3;
 "closing_hour" = "10:00 PM";
 code = AHU672;
 commission = 20;
 "commission_base" = 0;
 cost = "16819.38";
 "discount_label" = Nuevo;
 "display_address" = Obarrio;
 distance = "8856.31 Km";
 dob = "";
 document = "";
 email = "nurangelycarroz@gmail.com";
 "email_verified" = 1;
 entrydt = "2021-08-03 20:25:25";
 "free_delivery" = 1;
 "fssai_image" = "https://ambitious.in.net/Arun/appurados/";
 "fssai_no" = "";
 "gst_image" = "https://ambitious.in.net/Arun/appurados/";
 "gst_no" = 0410999465417;
 "gumasta_image" = "https://ambitious.in.net/Arun/appurados/";
 "gumasta_no" = "";
 "ifsc_code" = "0410999465417- ahorro";
 lat = "8.987292";
 liked = 1;
 likes = 1;
 lng = "-79.5204619";
 logo = "https://ambitious.in.net/Arun/appurados/uploads/user/logo8097WhatsApp Image 2021-08-03 at 3.16.24 PM.jpeg";
 "min_order_amount" = 0;
 mobile = 0050761216299;
 "mobile_verified" = 1;
 name = "Ahumados ";
 "offer_category_id" = 14;
 online = 0;
 "open_status" = 1;
 "opening_hour" = "11:00 AM";
 "order_count" = 0;
 "order_id" = "";
 otp = "";
 "over_commission" = 0;
 password = ahumados2020;
 "payment_email" = "";
 rating = "0.0";
 "refer_by" = "";
 "register_id" = "";
 review = 0;
 rewards = 0;
 "rider_plan_id" = 0;
 "service_radius" = 7;
 sex = "";
 "shipping_time" = 20;
 "social_id" = "";
 "social_type" = "";
 specialties = "Comida Ahumada ";
 speed = "40 KMPH";
 status = 1;
 "sub_category_id" = "";
 "swift_code" = "";
 time = "13284.46 mins";
 type = vendor;
 "under_commission" = 0;
 "user_id" = 67;
 "user_image" = "https://ambitious.in.net/Arun/appurados/uploads/user/784food-2879417_1920.jpg";
 wallet = 0;
 "working_days" = "Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday";
},
{
 */
