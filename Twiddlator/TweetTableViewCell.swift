//
//  TweetTableViewCell.swift
//  Twiddlator
//
//  Created by Julien Lecomte on 9/27/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
