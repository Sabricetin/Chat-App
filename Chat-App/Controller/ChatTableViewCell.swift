//
//  ChatTableViewCell.swift
//  Chat-App
//
//  Created by Sabri Çetin on 10.01.2025.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    let label = UILabel()
    let viewRow = UIView()
    
    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(viewRow)
        viewRow.layer.cornerRadius = 16
        viewRow.layer.masksToBounds = true
        viewRow.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(32)),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-32)),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(256)),
            label.topAnchor.constraint(equalTo: label.topAnchor, constant: CGFloat(16)),
            label.leadingAnchor.constraint(equalTo: label.leadingAnchor , constant: CGFloat(-16)),
            label.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: CGFloat(16)),
            label.trailingAnchor.constraint(equalTo: label.trailingAnchor , constant: CGFloat(16))
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        leadingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 32)
        leadingConstraint.isActive = true
        trailingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor , constant: -32)
        trailingConstraint.isActive = false
       
        
        // Configure the view for the selected state
    }
    
    override init(style : UITableViewCell.CellStyle , reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func messageType (isComing : Bool) {
        if isComing {
            viewRow.backgroundColor = .orange
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            
        } else {
            viewRow.backgroundColor = .blue
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
    }
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
}
