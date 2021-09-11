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
        
        if let banner_id = dict["banner_id"] as? String{
            self.strCategoryID = banner_id
        }else if let banner_id = dict["banner_id"] as? Int{
            self.strCategoryID = "\(banner_id)"
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

class ProductModel : NSObject{
    
    var strCategoryID: String = ""
    var strSubcategoryID:String = ""
    var strCategoryImage: String = ""
    var strCategoryName:String = ""
    var strSubCategoryName:String = ""
    var strProductName:String = ""
    var strProductId:String = ""
    var strProduuctDescription:String = ""
    
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
        
        if let product_id = dict["product_id"] as? String{
            self.strProductId = product_id
        }else if let product_id = dict["product_id"] as? Int{
            self.strProductId = "\(product_id)"
        }
        
        if let category_image = dict["category_image"] as? String{
            self.strCategoryImage = category_image
        }
        
        if let category_image = dict["category_image"] as? String{
            self.strCategoryImage = category_image
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
    }
    
}



