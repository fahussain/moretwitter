//
//  TwitterClient.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let consumerKey = "40iaNNtkMPAuwKdDkC2T6hR5Q"
let consumerSecret = "GYlax4vNX4HSufZGDvSXPSwZ2nGBOrFkGA8cMviVjxMVnmqNK4"
let baseUrl = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    let statusUpdateUrl = "1.1/statuses/update.json"
    let retweetUrl: String = "1.1/statuses/retweet/"
    let unRetweetUrl: String = "1.1/statuses/unretweet/"
    let likeUrl: String = "1.1/favorites/create.json"
    let unLikeUrl: String = "1.1/favorites/destroy.json"
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    static let userDidLoginNotification = NSNotification.Name(rawValue: "UserDidLogin")
    static let shared = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    func logout(){
        User.current = nil
        deauthorize()
        NotificationCenter.default.post(name: TwitterClient.userDidLogoutNotification, object: nil)
    }
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "moretwitter://ouauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                //print("Successfully opened the url")
            })
            
        }, failure: { (error: Error?) in
            if let error = error {
                self.loginFailure?(error)
            }
        })
    }
    func handleOpenUrl( url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentUser(success: { (user: User) in
                User.current = user
                TwitterClient.shared?.currentUser(success: { (user: User) in
                    self.loginSuccess?()
                }, failure: { (error: Error) in
                    print("Verfiy Credentials Error: \(error.localizedDescription)")
                })
            }, failure: { (error: Error) in
                print("no current user")
            })
            
        }, failure: { (error: Error?) in
            if let error = error {
                self.loginFailure?(error)
            }
        })
    }
    func apiPost(params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/update.json"
        post(url, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            success(response as! NSDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    func apiGet(url: String, params: NSDictionary = [:], success: @escaping ([Status]) -> (), failure: @escaping (Error) -> ()) {
        print("\(url)")
        get(url, parameters: params, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Status.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error:\(error.localizedDescription)")
            failure(error)
        })
    }
    func homeTimeline(params: NSDictionary = [:], success: @escaping ([Status]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Status.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error:\(error.localizedDescription)")
            failure(error)
        })
    }
    func currentUser(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            User.currentUser = user
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func likeTweet(destroy: Bool = false, params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        let url = (destroy ? unLikeUrl : likeUrl)
        post(url, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            success(response as! NSDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    func retweet(unRetweet: Bool = false, params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let url = (unRetweet ? unRetweetUrl : retweetUrl)+"\(params["id"]!).json"
        post(url,parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            success(response as! NSDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let getTweetUrl = "1.1/statuses/show/\(params["id"]!).json?include_my_retweet=1"
        get(getTweetUrl, parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
            //let currentUserRetweet = response["current_user_retweet"] as! NSDictionary
            //let retweetId = currentUserRetweet["id_str"] as! String
            //print(retweetId)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        /*
         TwitterClient.shared?.apiGet(params: params, success: { (dictionary: NSDictionary) in
         let currentUserRetweet = dictionary["current_user_retweet"] as! NSDictionary
         let retweetId = currentUserRetweet["id_str"] as! String
         print(retweetId)
         //let params: NSDictionary = ["id":retweetId]
         //let url = "1.1/statuses/destroy/" + retweetId + ".json"
         /*
         TwitterClient.shared?.apiPost(params: params, success: {
         (dictionary: NSDictionary) in
         // deleted the tweet go delete it from the tableview model
         }, failure: { (error: Error) in
         
         }) */
         }, failure: { (error: Error) in
         
         })*/
        
    }
    
    
}

