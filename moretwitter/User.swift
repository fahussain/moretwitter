//
//  User.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: URL?
    var profileBackgroundImageUrl: URL?
    var bannerImageUrl: URL?
    var tagline: String?
    var following: Int?
    var followers: Int?
    var id: Int?
    var idStr: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileImageUrl = URL(string: profileUrlString)
        }
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundImageUrlString = backgroundUrlString {
            bannerImageUrl = URL(string: backgroundImageUrlString)
        }
        let bannerUrlString = dictionary["profile_banner_url_https"] as? String
        if let bannerImageUrlString = bannerUrlString {
            bannerImageUrl = URL(string: bannerImageUrlString)
        }
        tagline = dictionary["description"] as? String
        following = (dictionary["following"] as? Int) ?? 0
        followers = (dictionary["friends_count"] as? Int) ?? 0
        id = (dictionary["friends"] as? Int) ?? 0
        idStr = dictionary["id_str"] as? String
    }
    static var _current: User?
    
    static var currentUser: User?
    
    class var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                if let userData = userData {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                        _current = User(dictionary: dictionary)
                    } catch {
                        return nil
                    }
                }
            }
            return _current
        }
        set(user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                    defaults.set(data, forKey: "currentUser")
                } catch {
                    defaults.set(nil, forKey: "currentUser")
                }
                
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            
            defaults.synchronize()
        }
    }
}
