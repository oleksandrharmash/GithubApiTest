//
//  ContributorTableViewCell.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import UIKit

class ContributorTableViewCell: UITableViewCell {
    static var identifier: String { return String(describing: self) }
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var contributionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 12.0
        avatarImageView.layer.masksToBounds = true
    }
    
    func show(_ contributor: Contributor) {
        usernameLabel.text = contributor.username
        contributionsLabel.text = "Commits: \(contributor.commits)"
        avatarImageView.setImage(withUrlPath: contributor.avatar,
                                 placeholer: .avatar)
    }
}
