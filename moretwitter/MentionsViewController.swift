//
//  MentionsViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var statuses: [Status] = []
    
    @IBOutlet weak var tableView: UITableView!
    weak var navigator: ViewNavigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let tweetNib = UINib(nibName: "TweetCell", bundle: nil)
        //let profileNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(tweetNib, forCellReuseIdentifier: "TweetCell")
        //tableView.register(profileNib, forCellReuseIdentifier: "ProfileCell")
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        loadTweets()
        // Do any additional setup after loading the view.
    }
    @IBAction func onNewTap(_ sender: Any) {
        composeFor(status: nil)
    }
    @IBAction func onSignoutTap(_ sender: Any) {
        TwitterClient.shared?.logout()
    }

    func loadTweets(){
        TwitterClient.shared?.apiGet(url: TwitterApi.mentionsTimelineUrl, success: { (statuses: [Status]) in
            self.statuses = statuses
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error:\(error.localizedDescription)")
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweetCellDelegate = self
        cell.status = statuses[indexPath.row ]
        return cell
        
    }
    func showProfile(forUser: User?) {
        navigator?.navigateToProfileView(user: forUser)
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

}
