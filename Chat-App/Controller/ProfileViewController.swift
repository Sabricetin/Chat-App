//
//  ProfileViewController.swift
//  Chat-App
//
//  Created by Sabri Çetin on 10.01.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {

    
   
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUserInfo()
    }
    
    func getUserInfo() {
        let databaseRef = Database.database().reference()
        let auth = Auth.auth()
        
        databaseRef.child(Child.USERS)
            .queryOrdered(byChild: "uid")
            .queryEqual(toValue: auth.currentUser!.uid)
            .observeSingleEvent(of: .value) { dataSnapshot in
                for child in dataSnapshot.children {
                    let snap = child as! DataSnapshot
                    let userInfo = UserInfo(snapshot: snap)
                    
                    self.infoLabel.text = userInfo.name
                    Helper.imageLoad(imageView: self.photoImageView, url: userInfo.photoUrl!)
                }
            }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
