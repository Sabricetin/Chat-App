//
//  RegisterViewController.swift
//  Chat-App
//
//  Created by Sabri Çetin on 8.01.2025.
//

import UIKit
import PhotosUI
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController  , UINavigationControllerDelegate {
    
    
    
    
   
    @IBOutlet weak var nameAndSurnameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepetitionTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let action = UITapGestureRecognizer(target: self, action: #selector(openGalery))
        userImageView.addGestureRecognizer(action)
        
        
    }
   @objc func openGalery() {
       
       var configuration = PHPickerConfiguration()
       configuration.filter = .images
       configuration.selectionLimit = 1
       
       
       let picker = PHPickerViewController(configuration: configuration)
       picker.delegate = self
       present(picker , animated : true)
       
       
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func register(_ sender: Any) {
        let name = nameAndSurnameTextField.text!
        let mail = mailTextField.text!
        let password = passwordTextField.text!
        let passwordRepetiton = passwordRepetitionTextField.text!
        
        if name.isEmpty || mail.isEmpty || password.isEmpty || passwordRepetiton.isEmpty {
            Helper.dialogMessage(message: "Alanlar Boş Olamaz", vc: self)
            return
        }
        
        if password != passwordRepetiton {
            Helper.dialogMessage(message: "Şifreler Aynı Olmalı " , vc: self)
            return
        }
        
        let databaseRef = Database.database().reference()
        print("databaseRef \(databaseRef)")
        let storageRef = Storage.storage().reference()
        let auth = Auth.auth()
        
        
        auth.createUser(withEmail: mail, password: password) {
            (userData , error) in
            if error != nil {
                Helper.dialogMessage(message: error!.localizedDescription, vc: self)
            } else {
                let imageName = UUID().uuidString + ".jpg"
                let path = "image"
                let imageRef = storageRef.child(path).child(imageName)
                imageRef.putData((self.userImageView.image?.jpegData(compressionQuality: 0.5))!) { metaData ,
                    error in
                    if error != nil {
                        Helper.dialogMessage(message: error!.localizedDescription, vc: self)
                    } else {
                        imageRef.downloadURL { url , error in
                            if error != nil {
                                Helper.dialogMessage(message: error!.localizedDescription , vc: self)
                            } else {
                                print(url?.absoluteString)
                                let userData = ["name" : name , "mail" : mail , "photoURL": url?.absoluteString]
                                databaseRef.child(Child.USERS).childByAutoId().setValue(userData) { error, databaseReference in
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as!
                                    HomeViewController;  self.present(vc , animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
   
    
}

extension RegisterViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true  , completion: nil)
        
        guard let firstResult = results.first else {return}
        if firstResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            firstResult.itemProvider.loadObject(ofClass:
                                                    UIImage.self) { image , error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.userImageView.image = image
                    }
                } else {
                    print("Resim Yükelenemedi : \(String(describing : error))")
                }
            }
        }
    }
}
