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
    var chatLastInfo : NSDictionary!
    
    
    var recipientName = ""
    var recipientUid = ""
    var rowKeyChatInbox : String = ""
    var rowKeyChatLast : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        setupTableAndInitDB()
        createChat()
    }
    
    func createChat () {
        
        databaseRef.child(Child.CHAT_INBOX)
                    .queryOrdered(byChild: "senderUid")
                    .queryEqual(toValue: self.auth.currentUser?.uid)
                    .observeSingleEvent(of: .value) { dataSnapshot in
                        print("creteChat observeSingleEvent:")
                        for child in dataSnapshot.children {
                            let snap = child as! DataSnapshot
                            let dict = snap.value as! NSDictionary
                            print (" createChat dict:  \(dict)")
                            if (dict["recipientUid"] as! String) == self.recipientUid {
                                self.chatInboxInfo = dict
                                
                               // self.rowKeyChatInbox = snap.key
                                self.databaseRef.child(Child.CHAT_INBOX)
                                    .queryOrdered(byChild: "senderUid")
                                    .queryEqual(toValue: self.recipientUid)
                                    .observe(.value) { dataSnapshot in
                                        for child in dataSnapshot.children {
                                            let snap = child as! DataSnapshot
                                            self.rowKeyChatInbox = snap.key
                                        }
                                    }
                                self.databaseRef.child(Child.CHAT_LAST)
                                    .queryOrdered(byChild: "inboxKey")
                                    .queryEqual(toValue: (dict["inboxKey"] as! String))
                                    .observe (.value) { dataSnapshot in
                                        for child in dataSnapshot.children {
                                            let snap = child as! DataSnapshot
                                            self.rowKeyChatLast = snap.key
                                        }
                                    }
                            
                            }
                        
                    
                  
                    
                }
                        self.createChatInboxAndLastChat()
                        self.chats()
                        self.chatLast()
                        /*
                         self.createChatInboxAndLastChat()
                         self.chats()
                         son chati oluştur
                         chatler
                         son chat */
            }
        
        
        
    }
    func chatLast() {
        databaseRef.child(Child.CHAT_LAST)
            .queryOrdered(byChild: "inboxKey")
            .queryEqual(toValue: (self.chatInboxInfo["inboxKey"] as!  String))
            .observe(.childChanged) { dataSnapshot in
                if let dict = dataSnapshot.value as? NSDictionary {
                    let messageKey = dict["messageKey"] as! String
                    self.databaseRef.child(Child.CHATS)
                    //BURAYA DİKKAT ET
                        .child(messageKey)
                        .observeSingleEvent(of: .value) { dataSnapshot in
                            if let messageListItem = MessageListItem(snapshot: dataSnapshot) {
                                self.list.append(messageListItem)
                            }
                            self.messageTableView.reloadData()
                            self.tableViewScrollToBottom(animated: false)
                            
                        }
                }
            }
    }
    
    
    func createChatInboxAndLastChat () {
        
        if chatInboxInfo == nil {
            let key = databaseRef.childByAutoId().key
            
            //Gönderen
            
            chatInboxInfo = [ "inboxKey" : key! , "senderUid": self.auth.currentUser!.uid , "recipientUid":self.recipientUid , "isRead" : "0"]
            databaseRef.child(Child.CHAT_INBOX).childByAutoId().setValue(chatInboxInfo)
            
            //Alıcı
            chatInboxInfo = [ "inboxKey" : key! , "senderUid": self.recipientUid , "recipientUid":self.auth.currentUser!.uid , "isRead" : "0"]
            databaseRef.child(Child.CHAT_INBOX).childByAutoId().setValue(chatInboxInfo) { error, databaseReference in
                self.rowKeyChatInbox = databaseReference.key!
            }
            
            //Son Mesaj
            
            self.chatLastInfo = ["inboxKey" : key! , "messageKey" : "" ]
            databaseRef.child(Child.CHAT_LAST).childByAutoId().setValue(chatLastInfo) { error, databaseReference in
                self.rowKeyChatLast = databaseReference.key!
                
                
            }
        }
        
        
    }
    
    func chats() {
        databaseRef.child(Child.CHATS)
            .queryOrdered(byChild: "inboxKey")
            .queryEqual(toValue: (self.chatInboxInfo!["inboxKey"] as! String))
            .observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot ,
                       let message = MessageListItem(snapshot: childSnapshot) {
                        self.list.append(message)
                    }
                    
                }
                self.messageTableView.reloadData()
                self.tableViewScrollToBottom(animated: true)
                
            }
        
    }
    
    func setupTableAndInitDB () {
        databaseRef = Database.database().reference()
        auth = Auth.auth()
        navbar.topItem?.title = recipientName
        
        self.messageTableView.register(ChatTableViewCell.self , forCellReuseIdentifier: "chatTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
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
                self.messageTableView.scrollToRow(at: IndexPath(row: (self.list.count - 1 ), section: 0) , at: .bottom , animated: animated)
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
            let senderUid = auth.currentUser!.uid
            let message = textMessageTextField.text!
            let postData = ["inboxKey":inboxKey, "senderUid":senderUid, "message":message]
            
            databaseRef.child(Child.CHATS).childByAutoId().setValue(postData) { error, dbRef in
                self.textMessageTextField.text = ""
                self.databaseRef.child(Child.CHAT_LAST).child(self.rowKeyChatLast).child("messageKey").setValue(dbRef.key!)
                self.databaseRef.child(Child.CHAT_INBOX).child(self.rowKeyChatInbox).child("isRead").setValue("1")
            }
            
        
        
        
    }
}
    
    extension  ChatViewController : UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return list.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell") as! ChatTableViewCell
            let info = self.list[indexPath.row]
            if self.auth.currentUser!.uid == info.senderUid {
                cell.messageType(isComing: false)
            } else {
                cell.messageType(isComing: true)
                
            }
            cell.label.text = info.message
            
            return cell
            
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            self.view.endEditing(true)
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        
    }
    

