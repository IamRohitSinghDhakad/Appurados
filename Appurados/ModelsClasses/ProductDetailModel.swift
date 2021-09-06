//
//  ProductDetailModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 07/09/21.
//

import UIKit

class ProductDetailModel: NSObject {
    
    var strProductID: String = ""
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
        
        if let product_id = dict["product_id"] as? String{
            self.strProductID = product_id
        }else if let product_id = dict["product_id"] as? Int{
            self.strProductID = "\(product_id)"
        }
        
        if let banner_image = dict["image"] as? String{
            self.strBannerImage = banner_image
        }
        
        
        if let logo = dict["vendor_logo"] as? String{
            self.strRastaurentImg = logo
        }
        
        if let discount_label = dict["discount_label"] as? String{
            self.strDiscountLabel = discount_label
        }
        
        if let specialties = dict["vendor_name"] as? String{
            self.strSpecialties = specialties
        }
        
        if let name = dict["product_name"] as? String{
            self.strVendorName = name
        }
        
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
        
        if let time = dict["time"] as? String{
            self.strTime = time
        }
        
        
        if let min_order_amount = dict["price"] as? String{
            self.strMinimumOrderAmount = min_order_amount
        }else if let min_order_amount = dict["price"] as? Int{
            self.strMinimumOrderAmount = "\(min_order_amount)"
        }
        
    }

}


/*
 
 {
     "addon_item_image" = "";
     "addon_item_name" = "";
     "addon_item_price" = "";
     "cart_count" = 0;
     "category_id" = 3;
     "category_name" = Restaurantes;
     description = "Cuatro Piezas Frescas de At\U00fan, Tres de Salm\U00f3n, Tres de Pescado Blanco y Dos de Kani, Acompa\U00f1adas con ajonjol\U00ed, Wasabi y Soya.";
     discount = "";
     entrydt = "2021-08-12 16:26:03";
     image = "https://ambitious.in.net/Arun/appurados/uploads/product/39347SashimiEspecial1.jpg.jpg";
     "max_addon" = 0;
     mrp = "16.75";
     price = "16.75";
     "product_id" = 1347;
     "product_name" = "Sashimi Especial ";
     "product_type" = "";
     recommended = 1;
     status = 1;
     stock = 0;
     "sub_category_id" = 250;
     "sub_category_name" = "Sashimis y Nigiris ";
     "variant_name" = "";
     "variant_price" = "";
     "vendor_id" = 66;
     "vendor_logo" = "https://ambitious.in.net/Arun/appurados/uploads/user/logo6823WhatsApp Image 2021-07-30 at 2.49.22 PM.jpeg";
     "vendor_name" = "Daiko Sushi";
 }
 */
