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

    var countdownLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        var navbar = navigationController?.navigationBar
        countdownLabel = UILabel(frame: CGRectMake(280, 16, 40, 30))
        countdownLabel.font = UIFont(name: "Helvetica", size: 12)
        countdownLabel.text = "140"
        countdownLabel.sizeToFit()
        navbar?.addSubview(countdownLabel)

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

    func textViewDidChange(textView: UITextView) {
        var n = 140 - countElements(textView.text)

        countdownLabel.text = "\(n)"

        if n < 10 {
            countdownLabel.textColor = UIColor.redColor()
        } else if n < 30 {
            countdownLabel.textColor = UIColor.orangeColor()
        } else {
            countdownLabel.textColor = UIColor.blackColor()
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        var newLength = countElements(textView.text) - range.length + countElements(text)
        if newLength <= 140 {
            return true
        }

        return false
    }
}
