//
//  ChatViewController.swift
//  Chat-App
//
//  Created by Sabri Çetin on 10.01.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ChatViewController: UIViewController {
    
    

    @IBOutlet weak var textMessageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var viewSendBottomConstraint: NSLayoutConstraint!
    
    var databaseRef : DatabaseReference!
    var list = [MessageListItem]()
    var auth : Auth!
    var chatInboxInfo : NSDictionary!
    
    var recipientName = ""
    var recipientUid = ""
    var rowKeyChatInBox : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setUpTableAndInitDB()
        createChat()
    }
    
    func createChat () {
        
        databaseRef.child(Child.CHAT_INBOX)
            .queryOrdered(byChild: "senderUid")
            .queryEqual(toValue: self.auth.currentUser?.uid)
            .observeSingleEvent(of: .value) { dataSnapshot in
                for child in dataSnapshot.children {
                    let snap = child as! DataSnapshot
                    let dic = snap.value as! NSDictionary
                    if (dic["recepintUid"] as! String) ==
                        self.recipientUid {
                        self.chatInboxInfo = dic
                        
                        self.databaseRef.child(Child.CHAT_INBOX)
                            .queryOrdered(byChild: "senderUid")
                            .queryEqual(toValue: self.recipientUid)
                            .observe(.value) { dataSnapshot in
                                for child in dataSnapshot.children {
                                    let snap = child as! DataSnapshot
                                    self.rowKeyChatInBox = snap.key
                                    
                                }
                                
                                
                            }
                        
                        self.databaseRef.child(Child.CHAT_LAST)
                            .queryOrdered(byChild: "inboxKey")
                            .queryEqual(toValue: (dic["inboxKey"] as! String))
                            .observe(.value) { dataSnapShot in
                                for child in dataSnapshot.children {
                                    let snap = child as! DataSnapshot
                                    self.rowKeyChatInBox = snap.key
                                }
                            }
                    }
                    /* son chati oluştur
                    chatler
                    son chat */
                    
                }
            }
        
        
        
    }
    
    
    
    func setUpTableAndInitDB () {
        databaseRef = Database.database().reference()
        auth = Auth.auth()
        navbar.topItem?.title = recipientName
        
        self.messageTableView.register(ChatTableViewCell.self , forCellReuseIdentifier: "chatTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    @objc func keyboardWillShow(notification : Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                                   as? NSValue)?.cgRectValue {
                self.viewSendBottomConstraint.constant =
                keyboardSize.height - self.view.safeAreaInsets.bottom
                self.tableViewScrollToBottom(animated: true)
            }
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        UIView.animate(withDuration: 0  , delay: 0 , options: .curveEaseOut ) {
            self.view.layoutIfNeeded()
        } completion: { bool in
            if self.list.count > 0 {
                self.messageTableView.scrollToRow(at: IndexPath(row: (self.list.count - 1 ), section: 0) , at: .bottom,
                animated: animated)
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification : Notification) {
        
        self.viewSendBottomConstraint.constant = 0
        
    }
    

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSendMessage(_ sender: Any) {
        
        let inboxKey = chatInboxInfo["inboxKey"] as! String
        let senderUid = auth.currentUser?.uid
        let message = textMessageTextField.text!
        let postData = [
            "inboxKey" : inboxKey ,
            "senderUid" : senderUid ,
            "message" : message ,
        ]
        databaseRef.child(Child.CHATS).childByAutoId()
            .setValue(postData) { error, dbRef in
                self.textMessageTextField.text = ""
                self.databaseRef.child(Child.CHAT_LAST).child(self.rowKeyChatInBox).child("messageKey").setValue(dbRef.key)
                self.databaseRef.child(Child.CHAT_INBOX).child(self.rowKeyChatInBox)
                    .child("isRead").setValue("1")
            }
        
        
        
        
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
