//
//  CommentEntity.swift
//  Donnews
//
//  Created by Anton Nikitin on 28.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class CommentEntity: NSObject {
    var id: Int?
    var author_name: String?
    var text: String?
    var date: String?
    
    init(c_id: Int, author_name: String, text: String, date: String) {
        self.id = c_id
        self.author_name = author_name
        self.text = text
        self.date = date
    }
}
