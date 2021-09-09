//
//  CartItemsModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 10/09/21.
//

import UIKit

class CartItemsModel: NSObject {

    var strOrder_cart_id:String = ""
    var strProductImage:String = ""
    var strReceiver_name:String = ""
    var strQuantity:String = ""
    var strProductPrice:String = ""
    var strActualPrice:String = ""
    var strProductName:String = ""
 
    
    init(dict : [String:Any]) {
        
        if let order_cart_id = dict["order_cart_id"] as? String{
            self.strOrder_cart_id = order_cart_id
        }else if let order_cart_id = dict["order_cart_id"] as? Int{
            self.strOrder_cart_id = "\(order_cart_id)"
        }
        
        if let product_price = dict["product_price"] as? String{
            self.strProductPrice = product_price
        }else if let product_price = dict["product_price"] as? Int{
            self.strProductPrice = "\(product_price)"
        }
        
        if let price = dict["price"] as? String{
            self.strActualPrice = price
        }else if let price = dict["price"] as? Int{
            self.strActualPrice = "\(price)"
        }
        
        if let quantity = dict["quantity"] as? String{
            self.strQuantity = quantity
        }
      
        if let image = dict["image"] as? String{
            self.strProductImage = image
        }
        
        if let strProductName = dict["strProductName"] as? String{
            self.strProductName = strProductName
        }
        
      
    }
    
    
    /*
     {
         "addon_items" = "";
         entrydt = "2021-09-09 20:35:59";
         image = "https://ambitious.in.net/Arun/appurados/";
         "order_cart_id" = 55;
         "order_id" = "";
         price = "16.99";
         "product_id" = 1323;
         "product_name" = "20 Piezas & 4 salsas";
         "product_price" = "33.98";
         quantity = 2;
         status = 0;
         "user_id" = 2;
         "variant_name" = "";
         "vendor_id" = 68;
     }
     */
}
