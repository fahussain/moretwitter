//
//  TweetCell.swift
//  hamburger
//
//  Created by Faheem Hussain on 11/4/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit
protocol TweetCellDelegate: class {
    func showProfile(forUser: User?)
    func composeFor(status: Status?)
}


class TweetCell: UITableViewCell {
    weak var composer: TweetCellDelegate!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetStackView: UIStackView!
    weak var tweetCellDelegate: TweetCellDelegate?
    
    var status: Status! {
        didSet {
            nameLabel.text = status.user.name
            profileImageView.setImageWith(status.user.profileImageUrl!)
            screennameLabel.text = "@\(status.user.screenname!)"
            let dateFormatter = DateFormatter()
            timeAgoLabel.text = dateFormatter.timeSince(from: status.timestamp!, numericDates: true)
            retweetCountLabel.text = "\(status.retweetCount)"
            favoriteCountLabel.text = "\(status.favoritesCount)"
            if retweetButton.isSelected != status.reTweeted! {
                retweetButton.isSelected = status.reTweeted!
            }
            if favoriteButton.isSelected != status.favorited! {
                favoriteButton.isSelected = status.favorited!
            }
            if status.hasRetweetStatus {
                retweetStackView.isHidden = false
                retweetLabel.text = status.retweetStatus!.user.name!
            }else {
                retweetStackView.isHidden = true
            }
            statusTextLabel.text = status.text
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.onProfileImageTapGesture(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
    }
    func onProfileImageTapGesture(_ sender: UITapGestureRecognizer){
        tweetCellDelegate?.showProfile(forUser: status.user)
    }
    @IBAction func onReplyTap(_ sender: Any) {
        tweetCellDelegate?.composeFor(status: status)
    }
    @IBAction func onRetweetTap(_ sender: Any) {
        retweet()
    }
    @IBAction func onFavoriteTap(_ sender: Any) {
        favorite()
    }
    
    func retweet() {
        let params: NSDictionary = ["id" : status.id!]
        self.retweetButton.isSelected = !self.status.reTweeted!
        if self.retweetButton.isSelected {
            self.retweetCount(add: true)
        } else {
            self.retweetCount(add: false)
        }
        TwitterClient.shared?.retweet(unRetweet: status.reTweeted!, params: params, success: { (tweet: NSDictionary) in
            self.status.replaceWith(dictionary: tweet)
        }, failure: { (error: Error) in
            print("Retweet Error: \(error.localizedDescription)")
            self.retweetButton.isSelected = !self.status.reTweeted!
            if self.retweetButton.isSelected {
                self.retweetCount(add: true)
            } else {
                self.retweetCount(add: false)
            }
        })
    }
    func favorite(){
        let params: NSDictionary = ["id" : status.id!]
        self.favoriteButton.isSelected = !self.status.favorited!
        if self.favoriteButton.isSelected {
            self.favoriteCount(add: true)
        } else {
            self.favoriteCount(add: false)
        }
        TwitterClient.shared?.likeTweet(destroy: status.favorited!, params: params, success: { (tweet: NSDictionary) in
            self.status.replaceWith(dictionary: tweet)
        }, failure: { (error: Error) in
            print("Favorite Error: \(error.localizedDescription)")
            self.favoriteButton.isSelected = !self.status.favorited!
            if self.favoriteButton.isSelected {
                self.favoriteCount(add: true)
            } else {
                self.favoriteCount(add: false)
            }
        })
    }
    func favoriteCount(add: Bool){
        if add {
            favoriteCountLabel.text = favoriteCountLabel.text?.add(number: 1)
        }else {
            favoriteCountLabel.text = favoriteCountLabel.text?.add(number: -1)
        }
    }
    func retweetCount(add: Bool){
        if add {
            retweetCountLabel.text = retweetCountLabel.text?.add(number: 1)
        }else {
            retweetCountLabel.text = retweetCountLabel.text?.add(number: -1)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
