//
//  TweetDetailViewController.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/28/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet: Tweet?

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var statusTextView: UITextView!
    @IBOutlet var timestampLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        var author = tweet!.author!

        profileImage.setImageWithURL(NSURL(string: author.profileImageUrl!))
        screenNameLabel.text = author.userName!
        userNameLabel.text = "@\(author.screenName!)"
        statusTextView.text = tweet?.body
        timestampLabel.text = tweet?.createdAt
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
