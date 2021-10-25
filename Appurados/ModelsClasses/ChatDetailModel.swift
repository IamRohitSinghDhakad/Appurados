//
//  ChatDetailModel.swift
//  TeamUp
//
//  Created by Rohit Dhakad on 11/10/21.
//

import UIKit

class ChatDetailModel: NSObject {
    
    var strOpponentChatMessage : String = ""
    var strOpponentChatTime : String = ""
    var strReceiverID   : String = ""
    var strImageUrl   : String = ""
    var strMsgIDForDelete  : String = ""
    var strSenderId : String = ""
    var strChatTime   : String = ""
    var strType   : String = ""
    var strByAdmin    :String = ""
  
    
    init(dict : [String:Any]) {
       
        if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }else  if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }
        
        if let sender_id = dict["sender_id"] as? String{
            self.strSenderId = sender_id
        }else  if let sender_id = dict["sender_id"] as? String{
            self.strSenderId = sender_id
        }
        
        if let id = dict["message_id"] as? String{
            self.strMsgIDForDelete = id
        }else  if let id = dict["message_id"] as? String{
            self.strMsgIDForDelete = id
        }
        
        if let by_admin = dict["by_admin"] as? String{
            self.strByAdmin = by_admin
        }else  if let by_admin = dict["by_admin"] as? String{
            self.strByAdmin = by_admin
        }
        
        if let chat_image = dict["chat_image"] as? String{
            self.strImageUrl = chat_image.trim()
        }
        
        
        if let chat_Time = dict["created_at"]as? String{
            self.strChatTime = chat_Time
        }
        
        if let type = dict["type"]as? String{
            self.strType = type
        }
        
        
        
        if let chat_message = dict["message"] as? String{
            self.strOpponentChatMessage = chat_message.decodeEmoji
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strOpponentChatTime = time_ago
        }
        
      
    }
    
}




extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}
