//
//  CommentTVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 29.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class CommentTVC: UITableViewCell {
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 15)
        label.textColor = UIColor.authorColor
        return label
    }()
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 15)
        label.textColor = UIColor.leadColor
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.textColor = UIColor.leadColor
        return label
    }()
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.leadColor
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(authorLabel)
        addSubview(commentLabel)
        addSubview(dividerView)
        addSubview(dateLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: commentLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dividerView)
        addConstraintsWithFormat(format: "V:|-10-[v0]-5-[v1]-10-[v2(0.5)]|", views: authorLabel, commentLabel, dividerView)
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.5).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
