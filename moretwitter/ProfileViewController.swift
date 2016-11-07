//
//  ProfileViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeDelegate, UIGestureRecognizerDelegate, TweetCellDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var statuses: [Status] = []
    var user: User?
    weak var navigator: ViewNavigator?
    var profileCell: ProfileCell?
    
    @IBOutlet var uiPangeGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiPangeGesture.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        let tweetNib = UINib(nibName: "TweetCell", bundle: nil)
        let profileNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(tweetNib, forCellReuseIdentifier: "TweetCell")
        tableView.register(profileNib, forCellReuseIdentifier: "ProfileCell")
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        //self.user = User.currentUser
        
    }
    func refreshView() {
        loadTweets()
    }
    func loadTweets(){
        let url: String = TwitterApi.userTimelineUrl + "?screen_name=\(user!.screenname!)"
        TwitterClient.shared?.apiGet(url: url, success: { (statuses: [Status]) in
            self.statuses = statuses
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error:\(error.localizedDescription)")
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onNewTap(_ sender: Any) {
        composeFor(status: nil)
    }
    @IBAction func onSignoutTap(_ sender: Any) {
        TwitterClient.shared?.logout()
    }
    
    func composeFor(status: Status?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        if let sourceStatus = status {
            controller.status = sourceStatus
        }else {
            controller.status = nil
        }
        //self.navigationController?.pushViewController(controller, animated: true)
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count+1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.selectionStyle = .none
            self.profileCell = cell
            cell.user = user
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.status = statuses[indexPath.row - 1]
            cell.tweetCellDelegate = self
            return cell
        }
    }
    func showProfile(forUser: User?) {
        navigator?.navigateToProfileView(user: forUser)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 50 {
            profileCell?.posterImageView?.alpha = (60.0 - y)/100
        }
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .changed:
            if velocity.y < 0 && translation.y < 10{
                let alpha = (translation.y/10) + 0.5
                //print(translation.y)
                //profileCell?.posterImageView?.alpha = alpha
            }
        default:
            print("")
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

}
