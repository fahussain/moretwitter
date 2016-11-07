//
//  LoginViewController.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

protocol LoginDelegate: class{
    func navigateToMain()
}

class LoginViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLoginTap(_ sender: Any) {
        TwitterClient.shared?.login(success: {
            NotificationCenter.default.post(name: TwitterClient.userDidLoginNotification, object: nil)
            //self.performSegue(withIdentifier: "LoginAndShowHome", sender: self)
        }, failure: { (error: Error) in
            print("\(error.localizedDescription)")
        })
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
