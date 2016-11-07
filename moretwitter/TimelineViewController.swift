//
//  TimelineViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    var statuses: [Status] = []
    
    weak var navigator: ViewNavigator?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let tweetNib = UINib(nibName: "TweetCell", bundle: nil)
        tableView.register(tweetNib, forCellReuseIdentifier: "TweetCell")
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        loadTweets()
    }
    func loadTweets(){
        TwitterClient.shared?.apiGet(url: TwitterApi.homeTimelineUrl, success: { (statuses: [Status]) in
            self.statuses = statuses
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error:\(error.localizedDescription)")
        })
    }
    @IBAction func onNewTap(_ sender: Any) {
        composeFor(status: nil)
    }
    @IBAction func onSignoutTap(_ sender: Any) {
        TwitterClient.shared?.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
