//
//  UserListItem.swift
//  Chat-App
//
//  Created by Sabri Çetin on 9.01.2025.
//

import Foundation
import FirebaseDatabase



class UserListItem {
    var uid : String?
    var name : String?
    var photoUrl : String?
    var rowKey : String?
    var isRead: String?
    var recipientUid : String?

    init (name: String? , photoUrl: String? , rowKey: String? , isRead: String? , recipientUid : String? ) {
        self.recipientUid = recipientUid
        self.name = name
        self.photoUrl = photoUrl
        self.rowKey = rowKey
        self.isRead = isRead
     
    }

    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any ] else {
            return nil
        }
        
        self.uid = value["uid"] as? String
        self.name = value["name"] as? String ?? "bilinmiyor"
        self.photoUrl = value["photoURL"] as? String
        self.rowKey = snapshot.key
        self.isRead = value["isRead"] as? String
        self.recipientUid = value["recipientUid"] as? String
    }
}
