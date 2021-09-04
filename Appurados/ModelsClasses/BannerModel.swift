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
