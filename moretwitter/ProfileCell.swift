//
//  ProfileCell.swift
//  hamburger
//
//  Created by Faheem Hussain on 11/4/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    var user: User! {
        didSet {
            if user.bannerImageUrl != nil {
                posterImageView.setImageWith(user.bannerImageUrl!)
            } else {
                posterImageView.image = nil
            }
            profileImageView.setImageWith(user.profileImageUrl!)
            nameLabel.text = user.name
            screennameLabel.text = "@\(user.screenname!)"
            followingCountLabel.text = "\(user.following!)"
            followersCountLabel.text = "\(user.followers!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        posterImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
