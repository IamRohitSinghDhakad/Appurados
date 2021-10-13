//
//  BannerModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 05/09/21.
//

import UIKit

class BannerModel: NSObject {
    
    var strBannerID: String = ""
    var strBannerImage: String = ""
    var strBannerName:String = ""
    
    init(dict : [String:Any]) {
        
        if let banner_id = dict["banner_id"] as? String{
            self.strBannerID = banner_id
        }else if let banner_id = dict["banner_id"] as? Int{
            self.strBannerID = "\(banner_id)"
        }
        
        if let banner_image = dict["banner_image"] as? String{
            self.strBannerImage = banner_image
        }
        
        if let banner_name = dict["banner_name"] as? String{
            self.strBannerName = banner_name
        }
    }
}



class CaterogryModel: NSObject {
    
    var strCategoryID: String = ""
    var strCategoryImage: String = ""
    var strCategoryName:String = ""
    
    init(dict : [String:Any]) {
        
        if let category_id = dict["category_id"] as? String{
            self.strCategoryID = category_id
        }else if let category_id = dict["category_id"] as? Int{
            self.strCategoryID = "\(category_id)"
        }
        
        if let category_image = dict["category_image"] as? String{
            self.strCategoryImage = category_image
        }
        
        if let category_name = dict["category_name"] as? String{
            self.strCategoryName = category_name
        }
    }
}


class SubCategoryModel : NSObject{
    
    var strCategoryID: String = ""
    var strSubcategoryID:String = ""
    var strCategoryImage: String = ""
    var strCategoryName:String = ""
    var strSubCategoryName:String = ""
    
    init(dict : [String:Any]) {
        
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
        
        if let category_image = dict["category_image"] as? String{
            self.strCategoryImage = category_image
        }
        
        if let category_name = dict["category_name"] as? String{
            self.strCategoryName = category_name
        }
        
        if let sub_category_name = dict["sub_category_name"] as? String{
            self.strSubCategoryName = sub_category_name
        }
    }
    
}
//
//class ProductModel : NSObject{
//
//    var strCategoryID: String = ""
//    var strSubcategoryID:String = ""
//    var strCategoryImage: String = ""
//    var strCategoryName:String = ""
//    var strSubCategoryName:String = ""
//    var strProductName:String = ""
//    var strProductId:String = ""
//    var strProduuctDescription:String = ""
//    var strPrice:String = ""
//    var strProductImage:String = ""
//    var strVendorID:String = ""
// //   var strVendorID:String = ""
//
//    init(dict : [String:Any]) {
//
//        if let category_id = dict["category_id"] as? String{
//            self.strCategoryID = category_id
//        }else if let category_id = dict["category_id"] as? Int{
//            self.strCategoryID = "\(category_id)"
//        }
//
//        if let vendor_id = dict["vendor_id"] as? String{
//            self.strVendorID = vendor_id
//        }else if let vendor_id = dict["vendor_id"] as? Int{
//            self.strVendorID = "\(vendor_id)"
//        }
//
//        if let sub_category_id = dict["sub_category_id"] as? String{
//            self.strSubcategoryID = sub_category_id
//        }else if let sub_category_id = dict["sub_category_id"] as? Int{
//            self.strSubcategoryID = "\(sub_category_id)"
//        }
//
//        if let product_id = dict["product_id"] as? String{
//            self.strProductId = product_id
//        }else if let product_id = dict["product_id"] as? Int{
//            self.strProductId = "\(product_id)"
//        }
//
//        if let category_image = dict["category_image"] as? String{
//            self.strCategoryImage = category_image
//        }
//
//        if let category_image = dict["category_image"] as? String{
//            self.strCategoryImage = category_image
//        }
//
//        if let image = dict["image"] as? String{
//            self.strProductImage = image
//        }
//
//        if let product_name = dict["product_name"] as? String{
//            self.strProductName = product_name
//        }
//
//        if let category_name = dict["category_name"] as? String{
//            self.strCategoryName = category_name
//        }
//
//        if let sub_category_name = dict["sub_category_name"] as? String{
//            self.strSubCategoryName = sub_category_name
//        }
//
//        if let strDescription = dict["description"] as? String{
//            self.strProduuctDescription = strDescription
//        }
//
//        if let price = dict["price"] as? String{
//            self.strPrice = price
//        }else if let price = dict["price"] as? Int{
//            self.strPrice = "\(price)"
//        }
//
//    }
//
//}

class OrderDetailVariantModel {
    var arrTypes: [OrderDetailVariantTypeModel] = [OrderDetailVariantTypeModel]()
    var strVariant: String = ""
    var strVariantQty: String = ""
    var isSelected:Bool?
    
    init(dict : [String:Any]) {
        
        if let types = dict["types"]as? [[String:Any]]{
            for data in types{
                let objtypes = OrderDetailVariantTypeModel.init(dict: data)
                self.arrTypes.append(objtypes)
            }
        }
        
        if let variant = dict["variant"] as? String{
            self.strVariant = variant
        }
        
        if let variantQty = dict["variantQty"] as? String{
            self.strVariantQty = variantQty
        }else if let variantQty = dict["variantQty"] as? Int{
            self.strVariantQty = "\(variantQty)"
        }
    }

//    init(types: [OrderDetailVariantTypeModel], variant: String, variantQty: String) {
//        self.types = types
//        self.variant = variant
//        self.variantQty = variantQty
//    }
}

// MARK: - TypeElement
class OrderDetailVariantTypeModel: NSObject {
    var strPrice: String = ""
    var strType: String = ""
    var isSelected:Bool?

    init(dict : [String:Any]) {
        
        if let price = dict["price"] as? String{
            self.strPrice = price
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)"
        }
        
        if let type = dict["type"] as? String{
            self.strType = type
        }
        
    }
}


class OrderDetailModel : NSObject{
    
    var strProductName:String = ""
    var strProductId:String = ""
    var strPrice:String = ""
    var strProductType:String = ""
    var strProduuctDescription:String = ""
    var strProductImage:String = ""
    var strAddOnName:String = ""
    var arrAddOnName:[String] = [String]()
    var strAddOnPrice:String = ""
    var arrAddOnPrice:[String] = [String]()
    var arrVariant: [OrderDetailVariantModel] = [OrderDetailVariantModel]()
    
    init(dict : [String:Any]) {
        
        if let product_type = dict["product_type"] as? String{
            self.strProductType = product_type
        }
        
        if let product_name = dict["product_name"] as? String{
            self.strProductName = product_name
        }
        
        if let product_id = dict["product_id"] as? String{
            self.strProductId = product_id
        }else if let product_id = dict["product_id"] as? Int{
            self.strProductId = "\(product_id)"
        }
        
        if let price = dict["price"] as? String{
            self.strPrice = price
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)"
        }
        
        if let description = dict["description"] as? String{
            self.strProduuctDescription = description
        }
        
        if let addon_item_name = dict["addon_item_name"] as? String{
            self.strAddOnName = addon_item_name
        }
        
        if self.strAddOnName != ""{
            self.arrAddOnName = self.strAddOnName.components(separatedBy: ",")
        }
        
        if let addon_item_price = dict["addon_item_price"] as? String{
            self.strAddOnPrice = addon_item_price
        }else if let addon_item_price = dict["addon_item_price"] as? Int{
            self.strAddOnPrice = "\(addon_item_price)"
        }
        
        if self.strAddOnPrice != ""{
            self.arrAddOnPrice = self.strAddOnPrice.components(separatedBy: ",")
        }
        
        if let image = dict["image"] as? String{
            self.strProductImage = image
        }
        
//        if let localArrVariant = dict["variant"] as? [OrderDetailVariantModel]{
//            self.arrVariant = localArrVariant
//        }
        
        if let dataVariant = dict["variant"] as? [[String:Any]] {
            for data in dataVariant{
                let objVar = OrderDetailVariantModel.init(dict: data)
                self.arrVariant.append(objVar)
            }
        }
    }
    
}


/*
 {
     "addon_item_image" = "uploads/product/ADDON13097dummy.png,uploads/product/ADDON89322dummy.png,uploads/product/ADDON39679dummy.png";
     "addon_item_name" = "Cold Coffe,Cold Coffe,Cold Coffe";
     "addon_item_price" = "5,10,15";
     "cart_count" = 0;
     "category_id" = 3;
     "category_name" = Restaurantes;
     description = "This is dummy product just for testing";
     discount = 10;
     entrydt = "2021-09-22 20:05:04";
     image = "https://ambitious.in.net/Arun/appurados/uploads/product/86804img.png";
     "max_addon" = 2;
     mrp = 10;
     price = "9.00";
     "product_id" = 1383;
     "product_name" = "My Testing Product";
     "product_type" = breakfast;
     recommended = 0;
     status = 1;
     stock = 10;
     "sub_category_id" = 192;
     "sub_category_name" = Combo;
     variant =     (
                 {
             types =             (
                                 {
                     price = 0;
                     type = pollo;
                 },
                                 {
                     price = 0;
                     type = "carne ";
                 },
                                 {
                     price = 0;
                     type = cerdo;
                 }
             );
             variant = "Proteina agrega 1";
             variantQty = 1;
         },
                 {
             types =             (
                                 {
                     price = 0;
                     type = "Ensalada de Gallina";
                 },
                                 {
                     price = 5;
                     type = "Ensalada cesar";
                 }
             );
             variant = "Ensalada ";
             variantQty = 1;
         },
                 {
             types =             (
                                 {
                     price = 0;
                     type = Arroz;
                 },
                                 {
                     price = 0;
                     type = Pasta;
                 }
             );
             variant = "Agrega 1 ";
             variantQty = 1;
         }
     );
     "variant_name" = "";
     "variant_price" = "";
     "vendor_id" = 53;
     "vendor_logo" = "https://ambitious.in.net/Arun/appurados/uploads/user/logo1306logo.png";
     "vendor_name" = "Hyper Food";
 },
 */
 
