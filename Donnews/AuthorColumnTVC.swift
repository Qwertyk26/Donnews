//
//  AuthorColumnTVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 16.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class AuthorColumnTVC: UITableViewCell {
    
    var heightAnchorImage : NSLayoutConstraint?
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    let categoryTextView: PaddingLabel = {
        let textView = PaddingLabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.red
        textView.font = UIFont(name: "PTSans-Caption", size: 15)
        return textView
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 13)
        label.textColor = UIColor.leadColor
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSerif-Bold", size: 19)
        label.textColor = UIColor.black
        return label
    }()
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        label.textColor = UIColor.leadColor
        return label
    }()
    let postLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Caption", size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.leadColor
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.addSubview(coverImage)
        cardView.addSubview(categoryTextView)
        cardView.addSubview(dateLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(authorNameLabel)
        cardView.addSubview(postLabel)
        addSubview(cardView)
        addSubview(leadeLabel)
        addSubview(dividerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cardView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dividerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverImage)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-5-[v2]-10-|", views: cardView, leadeLabel, dividerView)
        addConstraintsWithFormat(format: "H:|[v0]-10-[v1]-10-|", views: coverImage, titleLabel)
        heightAnchorImage = coverImage.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorImage?.isActive = true
        categoryTextView.leftAnchor.constraint(equalTo: self.coverImage.rightAnchor, constant: 10).isActive = true
        categoryTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        categoryTextView.topAnchor.constraint(equalTo: self.coverImage.topAnchor).isActive = true
        authorNameLabel.topAnchor.constraint(equalTo: self.categoryTextView.bottomAnchor).isActive = true
        authorNameLabel.leftAnchor.constraint(equalTo: self.coverImage.rightAnchor, constant: 10).isActive = true
        postLabel.topAnchor.constraint(equalTo: self.authorNameLabel.bottomAnchor).isActive = true
        postLabel.leftAnchor.constraint(equalTo: self.coverImage.rightAnchor, constant: 10).isActive = true
        postLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.postLabel.bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCell(item: NewsEntity) {
        leadeLabel.text = item.lead
        categoryTextView.text = item.category_name
        titleLabel.text = item.title
        authorNameLabel.text = item.author_name
        let post = item.post?.replacingOccurrences(of: "<br>", with: " ")
        postLabel.text = post
        if (item.image_width < item.image_height) {
            heightAnchorImage?.constant = (item.image_width * UIScreen.main.bounds.height / 2) / item.image_height
            coverImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        } else {
            coverImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
            heightAnchorImage?.constant = (item.image_height * UIScreen.main.bounds.width / 2) / item.image_width
        }
        coverImage.sd_setImage(with: URL.init(string: item.image_full!))
    }
}

