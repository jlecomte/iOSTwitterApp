//
//  TwitterClient.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/26/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager, UIAlertViewDelegate {

    class var sharedInstance: TwitterClient {

        struct Static {
            static var instance: TwitterClient?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = TwitterClient(
                baseURL: NSURL(string: "https://api.twitter.com/1.1/"),
                consumerKey: "1zkB4CeczbniHaRH9hVT6139T",
                consumerSecret: "NDS2Oz485w3Ay4anaii2prfKgxd7tuoXwYq7ktd1jgCVZ4R6DN"
            )
        }

        return Static.instance!
    }

    func authorize() {

        fetchRequestTokenWithPath(
            "/oauth/request_token",
            method: "POST",
            callbackURL: NSURL(string: "twiddlator://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuthToken!) -> Void in

                println("Received request token \(requestToken)")
                var authURL = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)"
                UIApplication.sharedApplication().openURL(NSURL(string: authURL))

            },
            failure: {
                (error: NSError!) -> Void in

                println(error);

                UIAlertView(
                    title: "Error",
                    message: "Could not acquire OAuth request token. Please try again later.",
                    delegate: self,
                    cancelButtonTitle: "Dismiss").show()
            })
    }

    func handleOAuthCallback(queryString: String, success: (() -> Void)!) {

        fetchAccessTokenWithPath(
            "/oauth/access_token",
            method: "POST",
            requestToken: BDBOAuthToken(queryString: queryString),
            success: {
                (accessToken: BDBOAuthToken!) -> Void in

                println("Received access token \(accessToken) -> authentication successful")
                self.requestSerializer.saveAccessToken(accessToken)
                if success != nil {
                    success()
                }
            },
            failure: {
                (error: NSError!) -> Void in

                UIAlertView(
                    title: "Error",
                    message: "Could not acquire OAuth access token. Please try again later.",
                    delegate: self,
                    cancelButtonTitle: "Dismiss").show()
            })
    }

    func isAuthorized() -> Bool {
        return requestSerializer.accessToken != nil && !requestSerializer.accessToken.expired
    }

    func getTimeline(endpoint: String, user_id: String!, since_id: String!, max_id: String!, callback: (tweets: [Tweet]!, error: NSError!) -> Void) {

        var parameters = [String: String]()

        if since_id != nil {
            parameters["since_id"] = since_id
        } else if max_id != nil {
            parameters["max_id"] = max_id
        } else {
            parameters["since_id"] = "1"
        }

        if user_id != nil {
            parameters["user_id"] = user_id
        }

        GET(endpoint,
            parameters: parameters,
            success: {
                // Success
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

                var objects = response as [NSDictionary]
                var tweets: [Tweet] = []

                for object in objects {
                    var tweet = Tweet(jsonObject: object)
                    tweets.append(tweet)
                }

                callback(tweets: tweets, error: nil)
            },
            failure: {
                // Failure
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(tweets: nil, error: error)
            })
    }

    func getHomeTimeline(since_id: String!, max_id: String!, callback: (tweets: [Tweet]!, error: NSError!) -> Void) {

        getTimeline("statuses/home_timeline.json",
            user_id: nil,
            since_id: since_id,
            max_id: max_id,
            callback: callback)
    }

    func getMentionsTimeline(since_id: String!, max_id: String!, callback: (tweets: [Tweet]!, error: NSError!) -> Void) {

        getTimeline("statuses/mentions_timeline.json",
            user_id: nil,
            since_id: since_id,
            max_id: max_id,
            callback: callback)
    }

    func getUserTimeline(user_id: String!, since_id: String!, max_id: String!, callback: (tweets: [Tweet]!, error: NSError!) -> Void) {

        getTimeline("statuses/user_timeline.json",
            user_id: user_id,
            since_id: since_id,
            max_id: max_id,
            callback: callback)
    }

    func getMyTimeline(since_id: String!, max_id: String!, callback: (tweets: [Tweet]!, error: NSError!) -> Void) {

        getUserTimeline(nil, since_id: since_id, max_id: max_id, callback: callback)
    }

    func getUserInfo(user_id: String!, callback: (user: User!, error: NSError!) -> Void) {

        var endpoint: String
        var parameters = [String: String]()

        if user_id == nil {
            endpoint = "account/verify_credentials.json"
        } else {
            endpoint = "users/show.json"
            parameters["user_id"] = user_id
        }

        GET(endpoint,
            parameters: parameters,
            success: {
                // Success
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

                var jsonObject = response as NSDictionary
                var user = User(jsonObject: jsonObject)
                callback(user: user, error: nil)
            },
            failure: {
                // Failure
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(user: nil, error: error)
            })
    }

    func sendPostRequest(endpoint: String, parameters: [String: String]!, callback: (error: NSError!) -> Void) {

        POST(endpoint,
            parameters: parameters,
            success: {
                // Success
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                callback(error: nil)
            },
            failure: {
                // Failure
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(error: error)
            })
    }

    func tweet(status: String, callback: (error: NSError!) -> Void) {

        sendPostRequest("statuses/update.json",
            parameters: [ "status": status ],
            callback: callback)
    }

    func retweet(tweet_id: String, callback: (error: NSError!) -> Void) {

        sendPostRequest("statuses/retweet/\(tweet_id).json",
            parameters: nil,
            callback: callback)
    }

    func favorite(tweet_id: String, callback: (error: NSError!) -> Void) {

        sendPostRequest("favorites/create.json",
            parameters: [ "id": tweet_id ],
            callback: callback)
    }

    func unfavorite(tweet_id: String, callback: (error: NSError!) -> Void) {

        sendPostRequest("favorites/destroy.json",
            parameters: [ "id": tweet_id ],
            callback: callback)
    }
}
