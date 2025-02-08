//
//  UserInfo.swift
//  Chat-App
//
//  Created by Sabri Çetin on 9.02.2025.
//

import Foundation
import FirebaseDatabase

class UserInfo {
    var name: String?
    var photoUrl: String?
    
    
    init(snapshot: DataSnapshot) {
        print("UserInfo \(snapshot)")
        if let dict = snapshot.value as! NSDictionary? {
            print("dict \(snapshot)")
            name = dict["name"] as? String
            photoUrl = dict["photoURL"] as? String
        }
    }
     
    
    
}
