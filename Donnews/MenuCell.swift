//
//  MenuCell.swift
//  Donnews
//
//  Created by Anton Nikitin on 24.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "PTSans-Caption", size: 17)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? UIColor.white : UIColor(white: 1, alpha: 0.5)
        }
    }
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.white : UIColor(white: 1, alpha: 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupViews() {
        addSubview(titleLabel)
        
        titleLabel.textColor = UIColor(white: 1, alpha: 0.5)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }
}
