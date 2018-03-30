//
//  NewsCell.swift
//  Donnews
//
//  Created by Anton Nikitin on 27.04.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    var _heightAnchor : NSLayoutConstraint?
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: "PTSerif-Bold", size: 24)
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
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
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
        addSubview(titleLabel)
        addSubview(leadeLabel)
        addSubview(categoryLabel)
        addSubview(dividerView)
        addSubview(coverImage)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: leadeLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dividerView)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-3-[v2]-3-[v3]-5-[v4]-10-|", views: coverImage, titleLabel, leadeLabel, categoryLabel, dividerView)
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        _heightAnchor = coverImage.heightAnchor.constraint(equalToConstant: 0)
        _heightAnchor?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCell(item: NewsEntity) {
        titleLabel.text = item.title
        leadeLabel.text = item.lead
        coverImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
       if (item.image_width < item.image_height) {
            _heightAnchor?.constant = (item.image_width * UIScreen.main.bounds.height) / item.image_height
        } else {
            _heightAnchor?.constant = (item.image_height * UIScreen.main.bounds.width) / item.image_width
        }
        coverImage.sd_setImage(with: URL(string: item.image_full!))
    }
}
