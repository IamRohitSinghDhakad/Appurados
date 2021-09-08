//
//  RewardModel.swift
//  Appurados
//
//  Created by Rohit Singh on 08/09/21.
//

import UIKit

class RewardModel: NSObject {

    var strRemark:String = ""
    var strRewardID:String = ""
    var strTimeAgo:String = ""
    var strPoints:String = ""
    var strTotalPoints:String = ""
    
    var arrCart = [OrdersCartDetailModel]()
    
    init(dict : [String:Any]) {
        
        if let reward_id = dict["reward_id"] as? String{
            self.strRewardID = reward_id
        }else if let reward_id = dict["reward_id"] as? Int{
            self.strRewardID = "\(reward_id)"
        }
        
        if let remark = dict["remark"] as? String{
            self.strRemark = remark
        }
        
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeAgo = time_ago
        }
        
        if let points = dict["points"] as? String{
            self.strPoints = points
        }else if let points = dict["points"] as? Int{
            self.strPoints = "\(points)"
        }
        
    }
    
    /*
     {
         datetime = "2021-08-28 23:40:32";
         entrydt = "2021-08-28 18:10:32";
         points = 10;
         remark = "Order Reward";
         "reward_id" = 23;
         "time_ago" = "1 week ago";
         "user_id" = 2;
     },
     */
    
}
