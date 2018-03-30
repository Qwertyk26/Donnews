//
//  ViewPagerTabType.swift
//  Donnews
//
//  Created by Anton Nikitin on 02.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import Foundation
import UIKit

enum ViewPagerTabType {
    case basic
    case image
    case imageWithText
}

class ViewPagerTab:NSObject {
    
    var title:String!
    var image:UIImage?
    
    init(title:String, image:UIImage?) {
        self.title = title
        self.image = image
    }
}
