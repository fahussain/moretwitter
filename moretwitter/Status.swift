//
//  Status.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

class Status: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool?
    var reTweeted: Bool?
    var id: Int?
    var user: User!
    var retweetStatus: Status?
    var hasRetweetStatus: Bool = false
    var idStr: String?
    init(dictionary: NSDictionary){
        super.init()
        setFrom(dictionary: dictionary)
    }
    
    func setFrom(dictionary: NSDictionary){
        //print("\(dictionary)")
        var tweetDictionary: NSDictionary = dictionary

        idStr = tweetDictionary["created_at"] as? String
        id = (tweetDictionary["id"] as? Int) ?? 0
        idStr = tweetDictionary["id_str"] as? String
        favoritesCount = (tweetDictionary["favorite_count"] as? Int) ?? 0
        favorited = tweetDictionary["favorited"] as? Bool
        reTweeted = tweetDictionary["retweeted"] as? Bool
        user = User(dictionary: tweetDictionary["user"] as! NSDictionary)
        let timestampString = tweetDictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        if let retweetedStatus = tweetDictionary["retweeted_status"] as? NSDictionary{
            hasRetweetStatus = true
            retweetStatus = Status(dictionary: retweetedStatus)
            tweetDictionary = retweetedStatus
        }
        text = tweetDictionary["text"] as? String
        retweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Status]{
        var tweets : [Status] = []
        var minId: Int64 = (dictionaries[0]["id"] as! NSNumber).int64Value
        for dictionary in dictionaries {
            let tweet = Status(dictionary: dictionary)
            if tweet.user.screenname == "codepath" {
                //print("\(dictionary)")
            }
            let tid = (dictionary["id"] as! NSNumber).int64Value
            if tid < minId {
                minId = tid
            }
            tweets.append(tweet)
        }
        return tweets
    }
    func replaceWith(dictionary: NSDictionary){
        setFrom(dictionary: dictionary)
    }
}
