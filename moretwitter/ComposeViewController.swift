//
//  ComposeViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

protocol ComposeDelegate: class {
    func composeFor(status: Status?)
}


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    let maxCharacters = 140
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var charactersRemainingLabel: UILabel!
    
    
    var status: Status?
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.setImageWith((User.current?.profileImageUrl)!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.masksToBounds = true
        statusTextView.delegate = self
        charactersRemainingLabel.text = "\(maxCharacters)"
        if status != nil {
            replyToLabel.text = "In reply to \(status!.user!.name!)"
            statusTextView.text = "@\(status!.user!.screenname!)"
            self.textViewDidChange(statusTextView)
        }else {
            replyToLabel.isHidden = true
        }
        statusTextView.becomeFirstResponder()
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        dismissMe()
    }
    @IBAction func onTweetTap(_ sender: Any) {
        postTweet()
    }
    func postTweet() {
        var params: NSDictionary!
        if status != nil {
            params = ["status": statusTextView.text, "in_reply_to_status_id": status!.id!]
        }else {
            params = ["status": statusTextView.text]
        }
        TwitterClient.shared?.apiPost(params: params
            , success: { (response: NSDictionary) in
                self.dismissMe()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
            
        })
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let tweetText = textView.text
        let charactersRemaining = maxCharacters - (tweetText?.characters.count)!
        charactersRemainingLabel.text = "\(charactersRemaining)"
        if charactersRemaining < 1 {
            let text = textView.text
            textView.text = text?.substring(to: (text?.index((text?.startIndex)!, offsetBy: maxCharacters))!)
            charactersRemainingLabel.text = "0"
        }
        charactersRemainingLabel.textColor = charactersRemaining >= 1 ? UIColor.lightGray : UIColor.red
        //self.adjustScrollViewContentSize()
        
    }

    func dismissMe() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
