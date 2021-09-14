//
//  OfferCategoryModel.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 10/09/21.
//

import UIKit

class OfferCategoryModel: NSObject {

    var strOffer_category_id:String = ""
    var strOffer_category_image:String = ""
    var strOffer_category_name:String = ""
    var isSelected:Bool = false
    
    init(dict : [String:Any]) {
        
        if let offer_category_id = dict["offer_category_id"] as? String{
            self.strOffer_category_id = offer_category_id
        }else if let offer_category_id = dict["offer_category_id"] as? Int{
            self.strOffer_category_id = "\(offer_category_id)"
        }
        
        if let offer_category_image = dict["offer_category_image"] as? String{
            self.strOffer_category_image = offer_category_image
        }
        
        if let offer_category_name = dict["offer_category_name"] as? String{
            self.strOffer_category_name = offer_category_name
        }
    }
    
    
    /*
     {
         discount = Arepas;
         entrydt = "2021-07-05 08:20:41";
         "offer_category_id" = 1;
         "offer_category_image" = "https://ambitious.in.net/Arun/appurados/uploads/category/offer_category6200AREPAS.jpg";
         "offer_category_name" = Arepas;
         status = 1;
     },
     */
    
}


class FilterModel {

//    var arrFilterData:[String]?
    var strIsSelected: Bool = false
    var strFilterData: String = ""
    
    init(filterString: String, isSelectedFilter: Bool) {
        self.strIsSelected = isSelectedFilter
        self.strFilterData = filterString
    
//        self.arrFilterData = ["RESTAURANTS WITHOUT MINIMUM ORDER", "NEW RESTAURANTS", "RECOMMENDED RESTAURANTS", "BEST RATED RESTAURANTS", "RESTAURANT FAVORITES", "FREE DELIVERY"]
        
    }
    
}
