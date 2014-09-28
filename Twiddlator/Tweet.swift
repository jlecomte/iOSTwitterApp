//
//  Tweet.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/26/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import Foundation

class Tweet {

    var uid: String?
    var author: User?
    var body: String?
    var createdAt: String?

    init(jsonObject: NSDictionary) {
        uid = jsonObject["id_str"] as? String
        body = jsonObject["text"] as? String
        createdAt = jsonObject["created_at"] as? String
        author = User(jsonObject: jsonObject["user"] as NSDictionary)

        // &amp; -> &
        body = body?.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)

        // Format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        var date = dateFormatter.dateFromString(createdAt!)
        dateFormatter.dateFormat = "MM/dd, h:mm a"
        createdAt = dateFormatter.stringFromDate(date!)
    }
}
