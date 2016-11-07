//
//  MenuViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit
protocol ViewNavigator: class{
    func navigateToProfileView(user: User?)
    func navigateToMentionsView(user: User?)
    func navigateToTimelineView(user: User?)
}
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewNavigator {
    

    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var timelineViewController: UIViewController!
    let menuTitles = ["Profile", "Mentions", "Home"]
    
    @IBOutlet weak var tableView: UITableView!
    
    var navigationControllers: [UIViewController] = []
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        timelineViewController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        if let pvc = profileViewController.childViewControllers[0] as? ProfileViewController{
            pvc.navigator = self
        }
        if let mvc = mentionsViewController.childViewControllers[0] as? MentionsViewController{
            mvc.navigator = self
        }
        if let tvc = timelineViewController.childViewControllers[0] as? TimelineViewController{
            tvc.navigator = self
        }
        navigationControllers.append(profileViewController)
        navigationControllers.append(mentionsViewController)
        navigationControllers.append(timelineViewController)
        navigateToProfileView(user: User.currentUser)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.titleLabel.text = menuTitles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigateToProfileView(user: User.currentUser)
            break
        case 1:
            hamburgerViewController.contentViewController = navigationControllers[indexPath.row]
            break
        case 2:
            hamburgerViewController.contentViewController = navigationControllers[indexPath.row]
            break
        default:
            print("no navgation for this menu item")
        }
        
    }
    func navigateToProfileView(user: User?) {
        if let pvc = profileViewController.childViewControllers[0] as? ProfileViewController{
            pvc.user = user
            pvc.title = user?.name!
            hamburgerViewController.contentViewController = profileViewController
            pvc.refreshView()
        }
        
    }
    func navigateToMentionsView(user: User?) {
        
    }
    func navigateToTimelineView(user: User?) {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
