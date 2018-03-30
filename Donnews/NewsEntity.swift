//
//  NewsEntity.swift
//  Donnews
//
//  Created by Anton Nikitin on 25.04.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Foundation

enum Category: String {
    case InterView = "interview"
    case Other = "other"
    case Stories = "stories"
    case Specprojects = "specproects"
    case AuthorColumn = "authorcolumn"
}

class NewsEntity: NSObject {
    
    var alias: String?
    var title: String?
    var text: String?
    var lead: String?
    var image_full: String?
    var image_width: CGFloat
    var image_height: CGFloat
    var category: Category
    var category_name: String?
    var comments_count: Int?
    var date: String?
    var author_name: String?
    var post: String?
    var expert_name: String?
    var expert_post: String?
    
    
    init(alias: String, category: Category, title: String, text: String, lead: String, image_full: String, image_width: CGFloat, image_height: CGFloat, category_name: String, comments_count: Int, date: String, post: String, expert_name: String, expert_post: String, author_name: String) {
        self.alias = alias
        self.category = category
        self.title = title
        self.text = text
        self.lead = lead
        self.image_full = image_full
        self.image_width = image_width
        self.image_height = image_height
        self.category_name = category_name
        self.comments_count = comments_count
        self.date = date
        self.post = post
        self.expert_name = expert_name
        self.expert_post = expert_post
        self.author_name = author_name
    }
}
