//
//  User.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/27/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import Foundation

class User {

    var uid: String?
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var followersCount: Int?
    var friendsCount: Int?
    var description: String?

    init(jsonObject: NSDictionary) {
        uid = jsonObject["id_str"] as? String
        name = jsonObject["name"] as? String
        screenName = jsonObject["screen_name"] as? String
        profileImageUrl = jsonObject["profile_image_url"] as? String
        followersCount = jsonObject["followers_count"] as? Int
        friendsCount = jsonObject["friends_count"] as? Int
        description = jsonObject["description"] as? String
    }
}
