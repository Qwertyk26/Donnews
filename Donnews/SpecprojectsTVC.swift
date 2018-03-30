//
//  SpecprojectsTVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 30.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class SpecprojectsTVC: UITableViewCell {

    var _heightAnchor : NSLayoutConstraint?
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let categoryTextView: PaddingLabel = {
        let textView = PaddingLabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.red
        textView.font = UIFont(name: "PTSans-Caption", size: 15)
        return textView
    }()
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.leadColor
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSerif-Bold", size: 24)
        label.textColor = UIColor.white
        return label
    }()
    let leadeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "PTSans-Caption", size: 15)
        label.textColor = UIColor.white
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.addSubview(coverImage)
        cardView.addSubview(categoryTextView)
        cardView.addSubview(titleView)
        cardView.addSubview(commentView)
        commentView.addSubview(commentCountLabel)
        commentView.addSubview(commentImage)
        titleView.addSubview(titleLabel)
        titleView.addSubview(leadeLabel)
        addSubview(cardView)
        addSubview(dividerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cardView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: leadeLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dividerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: coverImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverImage)
        addConstraintsWithFormat(format: "V:|[v0]-10-[v1(0.5)]-10-|", views: cardView, dividerView)
        addConstraintsWithFormat(format: "V:|[v0][v1]-5-|", views: titleLabel, leadeLabel)
        
        categoryTextView.leftAnchor.constraint(equalTo: self.cardView.leftAnchor, constant: 10).isActive = true
        categoryTextView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 10).isActive = true
        titleView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor).isActive = true
        commentView.rightAnchor.constraint(equalTo: self.cardView.rightAnchor, constant: -10).isActive = true
        commentView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 10).isActive = true
        commentView.addConstraintsWithFormat(format: "H:|[v0(22)]|", views: commentImage)
        commentView.addConstraintsWithFormat(format: "V:|[v0(23)][v1]|", views: commentImage, commentCountLabel)
        commentCountLabel.centerXAnchor.constraint(equalTo: commentView.centerXAnchor).isActive = true
        _heightAnchor = cardView.heightAnchor.constraint(equalToConstant: 0)
        _heightAnchor?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCell(item: NewsEntity) {
        titleLabel.text = item.title
        leadeLabel.text = item.lead
        categoryTextView.text = item.category_name
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
