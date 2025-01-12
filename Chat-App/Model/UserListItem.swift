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
   
    init(uid: String?, name: String, photoUrl: String) {
        self.uid = uid
        self.name = name
        self.photoUrl = photoUrl
    }
    
    init?(snapshot : DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else {
            return nil
        }
        self.uid = value["uid"] as? String
        self.name = value["name"] as? String ?? "biliniyor"
        self.photoUrl = value["photoURL"] as? String
    }
}
