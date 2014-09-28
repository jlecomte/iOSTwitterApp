//
//  LoginViewController.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/27/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.authorize()
    }
}
