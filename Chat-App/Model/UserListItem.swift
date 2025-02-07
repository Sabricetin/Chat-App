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
   

    init(uid: String  , name: String , photoUrl: String) {
        self.uid = uid
        self.name = name
        self.photoUrl = photoUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any ] else {
            return nil
        }
        
        self.uid = snapshot.key
        self.name = value["name"] as? String ?? "bilinmiyor"
        self.photoUrl = value["photoURL"] as? String
    }
}


/*
struct UserListItem {
    let uid: String
    let name: String
    let email: String
    let photoURL: String
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let name = dict["name"] as? String,
              let email = dict["mail"] as? String,
              let photoURL = dict["photoURL"] as? String else {
            return nil
        }
        
        self.uid = snapshot.key // UID, Firebase'de anahtar olarak tutuluyor!
        self.name = name
        self.email = email
        self.photoURL = photoURL
    }
}

*/
