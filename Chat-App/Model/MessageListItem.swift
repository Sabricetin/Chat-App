//
//  MessageListItem.swift
//  Chat-App
//
//  Created by Sabri Çetin on 10.01.2025.
//

import Foundation

class MessageListItem {
    
    var senderUid : String
    var message : String
  
    init(senderUid: String, message: String) {
        self.senderUid = senderUid
        self.message = message
    }
    
}
