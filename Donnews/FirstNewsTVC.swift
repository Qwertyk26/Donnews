//
//  FirstNewsCell.swift
//  Donnews
//
//  Created by Anton Nikitin on 25.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class FirstNewsTVC: UITableViewCell {
    var _heightAnchor : NSLayoutConstraint?
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let overlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.red
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.white
        label.font = UIFont(name: "PTSerif-Bold", size: 24)
        return label
    }()
    let leadLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.white
        label.font = UIFont(name: "PTSans-Caption", size: 15)
        return label
    }()
    let commentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let commentImage: UIImageView = {
        let commentImage = UIImageView(image: UIImage(named: "ic_comment"))
        commentImage.maskWith(color: UIColor.white)
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        return commentImage
    }()
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.addSubview(coverImage)
        cardView.addSubview(overlay)
        cardView.addSubview(titleLabel)
        cardView.addSubview(leadLabel)
        cardView.addSubview(commentView)
        commentView.addSubview(commentCountLabel)
        commentView.addSubview(commentImage)
        cardView.addSubview(dateLabel)
        addSubview(cardView)
        addConstraintsWithFormat(format: "V:|[v0]-10-|", views: cardView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cardView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: overlay)
        addConstraintsWithFormat(format: "H:|[v0]|", views: overlay)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: coverImage)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: leadLabel)
        
        commentView.rightAnchor.constraint(equalTo: self.cardView.rightAnchor, constant: -10).isActive = true
        commentView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 10).isActive = true
        commentView.addConstraintsWithFormat(format: "H:|[v0(22)]|", views: commentImage)
        commentView.addConstraintsWithFormat(format: "V:|[v0(23)][v1]|", views: commentImage, commentCountLabel)
        commentCountLabel.centerXAnchor.constraint(equalTo: commentView.centerXAnchor).isActive = true
        
        _heightAnchor = cardView.heightAnchor.constraint(equalToConstant: 0)
        _heightAnchor?.isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: leadLabel, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -3))
        
        addConstraint(NSLayoutConstraint(item: leadLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cardView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCell(item: NewsEntity) {
        titleLabel.text = item.title
        leadLabel.text = item.lead
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: item.date!)
        dateLabel.text = dateFormatter.timeSince(from: date! as NSDate, numericDates: true)
        if (item.comments_count == 0) {
            commentCountLabel.text = ""
        } else {
            commentCountLabel.text = String.init(format: "%d", item.comments_count!)
        }
        if (item.image_width < item.image_height) {
            _heightAnchor?.constant = (item.image_width * UIScreen.main.bounds.height) / item.image_height
        } else {
            _heightAnchor?.constant = (item.image_height * UIScreen.main.bounds.width) / item.image_width
        }
        coverImage.sd_setImage(with: URL(string: item.image_full!))
    }
}
