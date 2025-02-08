//
//  HomeTableViewCell.swift
//  Chat-App
//
//  Created by Sabri Çetin on 8.01.2025.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(userItem : UserListItem) {
        
       // self.imageView?.layer.cornerRadius = (imageView?.layer.frame.width)! / 2
        Helper.imageLoad(imageView: userImage, url: userItem.photoUrl!)
        userNameLabel.text = userItem.name
        
        
        
    }

}
