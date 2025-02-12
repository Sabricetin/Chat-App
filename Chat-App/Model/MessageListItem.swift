//
//  MessageListItem.swift
//  Chat-App
//
//  Created by Sabri Çetin on 10.01.2025.
//

import Foundation
import FirebaseDatabase

class MessageListItem {
    
    var senderUid : String?
    var message : String?
    var isRead: String?
  
    init(senderUid: String, message: String) {
        self.senderUid = senderUid
        self.message = message
    }
    
    init?(snapshot : DataSnapshot) {
        
        guard let snap = snapshot.value as? NSDictionary else {
            return nil
        }
        
            self.senderUid = snap["senderUid"] as? String ?? ""
            self.message = snap["message"] as? String ?? ""
            self.isRead = snap["isRead"] as? String ?? "false"

    }
    
}
