//
//  ViewController.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/26/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tweetListTableView: UITableView!

    var tweets: [Tweet] = []
    let client = TwitterClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetListTableView.delegate = self
        tweetListTableView.dataSource = self

        client.getHomeTimeline(nil, max_id: nil) {
            (tweets: [Tweet]!, error: NSError!) -> Void in

            if error == nil {
                self.tweets = tweets
                self.tweetListTableView.reloadData()
            } else {
                // TODO
                println(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TweetTableViewCell

        var cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        var tweet = tweets[indexPath.row]

        cell.profileImage.setImageWithURL(NSURL(string: tweet.author!.profileImageUrl!))
        cell.screenNameLabel.text = tweet.author?.screenName
        cell.userNameLabel.text = "@\(tweet.author!.userName!)"
        cell.createdAtLabel.text = tweet.createdAt
        cell.bodyLabel.text = tweet.body

        return cell
    }
}
