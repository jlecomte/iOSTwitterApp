//
//  ViewController.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/26/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class HomeTimeline: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogin(sender: AnyObject) {
        let client = TwitterClient.sharedInstance

        client.authorize()
    }
}
