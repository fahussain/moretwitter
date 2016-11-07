//
//  TwitterApi.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import Foundation

class TwitterApi {
    static let statusUpdateUrl = "1.1/statuses/update.json"
    static let retweetUrl: String = "1.1/statuses/retweet/"
    static let unRetweetUrl: String = "1.1/statuses/unretweet/"
    static let favoriteUrl: String = "1.1/favorites/create.json"
    static let destroyFavoriteUrl: String = "1.1/favorites/destroy.json"
    static let homeTimelineUrl: String = "1.1/statuses/home_timeline.json"
    static let mentionsTimelineUrl: String = "1.1/statuses/mentions_timeline.json"
    static let userTimelineUrl: String = "1.1/statuses/user_timeline.json"
}
