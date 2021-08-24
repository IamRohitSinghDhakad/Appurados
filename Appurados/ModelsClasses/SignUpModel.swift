//
//  SignUpModel.swift
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import UIKit

class SignUpModel: NSObject {

    var strName           : String = ""
    var strEmail          : String = ""
    var strPassword       : String = ""
    var strConfirmPassword : String = ""
    var strPhoneNo        : String = ""
    var strDialCode        : String = ""
    var strCountryCode    : String = ""
    var strDeviceToken    : String = ""
}

class userDetailModel: NSObject {
    var straAuthToken          : String = ""
  
   
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strName                  : String = ""
    var strPassword             : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    var strSocialId           : String = ""
    var strSocialType          : String = ""
    var strStatus            : String = ""
    var strUserId               : String = ""
    var strUserName             : String = ""
    
    var strlatitude :String = ""
    var strlongitude :String = ""
    var strAddress :String = ""
    var strDob    :String = ""
    var strGender    :String = ""
    var strCity      :String = ""
    var strState      :String = ""
    var strCountry      :String = ""
    var strLookingFor      :String = ""
    var strAge      :String = ""
    
    var strAboutMe :String = ""
    var strSpecialInstruction :String = ""
    var strHairColor :String = ""
    var strAllowSex :String = ""
    var strAllowCountry :String = ""
    var strAllowCity :String = ""
    var strAllowState :String = ""
    var strCinema :String = ""
    var strEye :String = ""
    var strHeight :String = ""
    var strMusic :String = ""
    var strSkinTone :String = ""
    var strSport :String = ""
    var strRelStatus: String = ""
    var valLikedStatus: Int = 0
    var valBlockedStatus: Int = 0
    var strBlockedBy: String = ""
    var strVisibilityStatus: String = ""
    var strMembershipStats:String = ""
    
    init(dict : [String:Any]) {
        
        if let userID = dict["user_id"] as? String{
            self.strUserId = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUserId = "\(userID)"
        }
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }else if let age = dict["age"] as? Int{
            self.strAge = "\(age)"
        }
        
        if let username = dict["name"] as? String{
            self.strUserName = username
        }
        
        if let strMembership = dict["has_membership"] as? String{
            self.strMembershipStats = strMembership
        }else if let strMembership = dict["has_membership"] as? Int{
            self.strMembershipStats = "\(strMembership)"
        }
        
        
        
        if let password = dict["password"] as? String{
            self.strPassword = password
        }
        
        if let short_bio = dict["short_bio"] as? String{
            self.strAboutMe = short_bio
        }
      
        
        if let hairColor = dict["hair"] as? String{
            self.strHairColor = hairColor
        }
        
        if let skin = dict["skin"] as? String{
            self.strSkinTone = skin
        }
        
      
        if let allow_sex = dict["allow_sex"] as? String{
            self.strAllowSex = allow_sex
        }else if let allow_sex = dict["allow_sex"] as? Int{
            self.strAllowSex = "\(allow_sex)"
        }
        
        if let allow_country = dict["allow_country"] as? String{
            self.strAllowCountry = allow_country
        }else if let allow_country = dict["allow_country"] as? Int{
            self.strAllowCountry = "\(allow_country)"
        }
        
        if let allow_city = dict["allow_city"] as? String{
            self.strAllowCity = allow_city
        }else if let allow_city = dict["allow_city"] as? Int{
            self.strAllowCity = "\(allow_city)"
        }
        
        if let allow_state = dict["allow_state"] as? String{
            self.strAllowState = allow_state
        }else if let allow_state = dict["allow_state"] as? Int{
            self.strAllowState = "\(allow_state)"
        }

        if let long = dict["lon"] as? String{
            self.strlongitude = long
        }else if let long = dict["lon"] as? Int{
            self.strlongitude = "\(long)"
        }
        
        if let phone_number = dict["mobile"] as? String{
            self.strPhoneNumber = phone_number
        }else if let phone_number = dict["mobile"] as? Int{
            self.strPhoneNumber = "\(phone_number)"
        }
        
        
        if let blocked = dict["blocked"] as? Int {
            self.valBlockedStatus = blocked
        }else if let blocked = dict["blocked"] as? String {
            self.valBlockedStatus = Int(blocked) ?? 0
        }
        
        if let blockedBy = dict["blockedBy"] as? String {
            self.strBlockedBy = blockedBy
        }
        
        if let visible = dict["visible"] as? String {
            self.strVisibilityStatus = visible
        }
        
        
        
    }
}

