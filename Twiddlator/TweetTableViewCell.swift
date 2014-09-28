//
//  TweetTableViewCell.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/27/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell, UITextViewDelegate {

    var tweet: Tweet?

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
