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

    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        MMProgressHUD.setPresentationStyle(MMProgressHUDPresentationStyle.None)

        tweetListTableView.delegate = self
        tweetListTableView.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tweetListTableView.addSubview(refreshControl)

        fetchTweets(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchTweets(since_id: String!) {
        client.getHomeTimeline(nil, max_id: nil) {
            (tweets: [Tweet]!, error: NSError!) -> Void in

            self.refreshControl.endRefreshing()

            if error == nil {
                self.tweets = tweets + self.tweets
                self.tweetListTableView.reloadData()
            } else {
                // TODO
                println(error)
            }
        }
    }

    func refresh(sender:AnyObject) {
        var since_id: String! = nil

        if tweets.count > 0 {
            since_id = tweets[0].uid
        }

        fetchTweets(since_id)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        var tweet = tweets[indexPath.row]

        cell.profileImage.setImageWithURL(NSURL(string: tweet.author!.profileImageUrl!))
        cell.screenNameLabel.text = tweet.author?.screenName
        cell.userNameLabel.text = "@\(tweet.author!.userName!)"
        cell.createdAtLabel.text = tweet.createdAt
        cell.bodyTextView.text = tweet.body

        // Additional data used for segue...
        cell.tweet = tweet

        return cell
    }

    @IBAction func onSignOut(sender: AnyObject) {
        client.deauthorize()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.showLogin()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetDetail" {
            var cell = sender as TweetTableViewCell
            var detailViewController = segue.destinationViewController as TweetDetailViewController
            detailViewController.tweet = cell.tweet
        }
    }
}
