//
//  ProductDetailModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 07/09/21.
//

import UIKit

class ProductDetailModel: NSObject {
    
    var strProductID: String = ""
    var strVendorName:String = ""
    var strAddress:String = ""
    var strRastaurentImg :String = ""
    var strDiscountLabel:String = ""
    var strSpecialties:String = ""
    var strDistance:String = ""
    var strTime:String = ""
    var strMinimumOrderAmount:String = ""
    var strCategoryID: String = ""
    var strSubcategoryID:String = ""
    var strCategoryImage: String = ""
    var strCategoryName:String = ""
    var strSubCategoryName:String = ""
    var strProductName:String = ""
    var strProduuctDescription:String = ""
    var strPrice:String = ""
    var strProductImage:String = ""
    var strVendorID:String = ""
    
    init(dict : [String:Any]) {
        
        if let product_id = dict["product_id"] as? String{
            self.strProductID = product_id
        }else if let product_id = dict["product_id"] as? Int{
            self.strProductID = "\(product_id)"
        }
        
        if let category_id = dict["category_id"] as? String{
            self.strCategoryID = category_id
        }else if let category_id = dict["category_id"] as? Int{
            self.strCategoryID = "\(category_id)"
        }
        
        if let sub_category_id = dict["sub_category_id"] as? String{
            self.strSubcategoryID = sub_category_id
        }else if let sub_category_id = dict["sub_category_id"] as? Int{
            self.strSubcategoryID = "\(sub_category_id)"
        }
        
        if let vendor_id = dict["vendor_id"] as? String{
            self.strVendorID = vendor_id
        }else if let vendor_id = dict["vendor_id"] as? Int{
            self.strVendorID = "\(vendor_id)"
        }
        
        
        if let category_image = dict["category_image"] as? String{
            self.strCategoryImage = category_image
        }
        
        if let image = dict["image"] as? String{
            self.strProductImage = image
        }
        
        
        if let product_name = dict["product_name"] as? String{
            self.strProductName = product_name
        }
        
        if let category_name = dict["category_name"] as? String{
            self.strCategoryName = category_name
        }
        
        if let sub_category_name = dict["sub_category_name"] as? String{
            self.strSubCategoryName = sub_category_name
        }
        
        if let strDescription = dict["description"] as? String{
            self.strProduuctDescription = strDescription
        }
        
        if let price = dict["price"] as? String{
            self.strPrice = price
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)"
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
 class ProductModel : NSObject{
 
 var strCategoryID: String = ""
 var strSubcategoryID:String = ""
 var strCategoryImage: String = ""
 var strCategoryName:String = ""
 var strSubCategoryName:String = ""
 var strProductName:String = ""
 var strProductId:String = ""
 var strProduuctDescription:String = ""
 var strPrice:String = ""
 var strProductImage:String = ""
 var strVendorID:String = ""
 //   var strVendorID:String = ""
 
 init(dict : [String:Any]) {
 
 
 
 
 
 
 
 }
 
 }
 */

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
