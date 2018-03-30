//
//  OtherTVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 27.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class OtherTVC: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSerif-Bold", size: 19)
        return label
    }()
    let leadeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "PTSans-Caption", size: 15)
        label.textColor = UIColor.leadColor
        return label
    }()
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.leadColor
        return view
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let commentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let commentImage: UIImageView = {
        let commentImage = UIImageView(image: UIImage(named: "ic_comment"))
        commentImage.maskWith(color: UIColor.commentsColor)
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        return commentImage
    }()
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.commentsColor
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(leadeLabel)
        addSubview(dividerView)
        addSubview(dateLabel)
        addSubview(commentView)
        commentView.addSubview(commentCountLabel)
        commentView.addSubview(commentImage)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: leadeLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dividerView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dateLabel)
        addConstraintsWithFormat(format: "V:|[v0]-15-[v1]-5-[v2]-10-[v3(0.5)]-10-|", views: dateLabel, titleLabel, leadeLabel, dividerView)
        commentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        commentView.addConstraintsWithFormat(format: "H:|[v0(22)]|", views: commentImage)
        commentView.addConstraintsWithFormat(format: "V:|[v0(23)][v1]|", views: commentImage, commentCountLabel)
        commentCountLabel.centerXAnchor.constraint(equalTo: commentView.centerXAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCell(item: NewsEntity) {
        titleLabel.text = item.title
        leadeLabel.text = item.lead
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: item.date!)
        dateLabel.text = dateFormatter.timeSince(from: date! as NSDate, numericDates: true)
        if (item.comments_count == 0) {
            commentCountLabel.text = ""
        } else {
            commentCountLabel.text = String.init(format: "%d", item.comments_count!)
        }
    }
}
