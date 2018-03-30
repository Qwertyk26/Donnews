//
//  EmptyTabelView.swift
//  Donnews
//
//  Created by Anton Nikitin on 29.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class EmptyTabelView: UIView {
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PTSans-Caption", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.leadColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emptyLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: emptyLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: emptyLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setTitle(title: String) {
        emptyLabel.text = title
    }
}
