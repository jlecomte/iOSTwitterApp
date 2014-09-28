//
//  ComposeViewController.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/27/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var statusTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        statusTextView.delegate = self
        statusTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        let client = TwitterClient.sharedInstance

        client.tweet(statusTextView.text) {
            (error: NSError!) -> Void in

            if error != nil {
                UIAlertView(
                    title: "Error",
                    message: "Your tweet could not be sent. Please try again later.",
                    delegate: self,
                    cancelButtonTitle: "Dismiss").show()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
