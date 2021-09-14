//
//  AddressModel.swift
//  Appurados
//
//  Created by Rohit Singh on 14/09/21.
//

import UIKit

class AddressModel: NSObject {
    
    var strAddress:String = ""
    var strAddress_name:String = ""
    var strLandmark:String = ""
    var strLatitude:String = ""
    var strLongitude:String = ""
    var strUserAddressID:String = ""
 
    
    init(dict : [String:Any]) {
        
        if let user_address_id = dict["user_address_id"] as? String{
            self.strUserAddressID = user_address_id
        }else if let user_address_id = dict["user_address_id"] as? Int{
            self.strUserAddressID = "\(user_address_id)"
        }
        
        if let lat = dict["lat"]as? String{
            self.strLatitude = lat
        }
        
        if let lng = dict["lng"]as? String{
            self.strLongitude = lng
        }
        
        if let landmark = dict["landmark"]as? String{
            self.strLandmark = landmark
        }
        
        if let address_name = dict["address_name"]as? String{
            self.strAddress_name = address_name
        }
        
        if let address = dict["address"]as? String{
            self.strAddress = address
        }
        
    }

}
