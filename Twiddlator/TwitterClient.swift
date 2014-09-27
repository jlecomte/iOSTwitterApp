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

            }, failure: {
                (error: NSError!) -> Void in

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
            }, failure: {
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
}
