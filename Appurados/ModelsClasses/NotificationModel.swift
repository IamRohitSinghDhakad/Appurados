//
//  NotificationModel.swift
//  Appurados
//
//  Created by Rohit Singh on 08/09/21.
//

import UIKit

class NotificationModel: NSObject {
    
    var strNotificationID:String = ""
    var strNotificationtitle:String = ""
    var strTimeAgo:String = ""
    
    init(dict : [String:Any]) {
        
        if let notification_id = dict["notification_id"] as? String{
            self.strNotificationID = notification_id
        }else if let notification_id = dict["notification_id"] as? Int{
            self.strNotificationID = "\(notification_id)"
        }
        
        if let notification_title = dict["notification_title"] as? String{
            self.strNotificationtitle = notification_title
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeAgo = time_ago
        }
    }

}
