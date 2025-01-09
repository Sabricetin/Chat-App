//
//  HomeViewController.swift
//  Chat-App
//
//  Created by Sabri Çetin on 8.01.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    var list = [UserListItem] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableLoad()
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController") as! SignInViewController
            self.present(vc , animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func tableLoad() {
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        let databaseRef = Database.database().reference()
        databaseRef.child(Child.USERS).observe(.value) { snapshot in
            
            self.list.removeAll()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot , let user = UserListItem(snapshot : childSnapshot){
                    print(user.name)
                    if user.uid != Auth.auth().currentUser?.uid {
                        
                        self.list.append(user)

                    }
                    
                    
                } else {
                    print("Veri Alımında Hata Var")
                }
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
            
          
            
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

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeIdentifier", for: indexPath) as! HomeTableViewCell
        cell.configure(userItem: list [indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
  
}

extension HomeViewController  : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         
    }
}
