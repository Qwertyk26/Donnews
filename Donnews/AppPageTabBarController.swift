//
//  AppPageTabBarController.swift
//  Donnews
//
//  Created by Anton Nikitin on 31.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material

class AppPageTabBarController: PageTabBarController {
    open override func prepare() {
        super.prepare()
        
        delegate = self
        preparePageTabBar()
        
        Motion.delay(time: 3) {
            self.selectedIndex == 0
        }
    }
}

extension AppPageTabBarController {
    fileprivate func preparePageTabBar() {
        pageTabBar.backgroundColor = UIColor.dividerColor
        pageTabBarAlignment = .top
        pageTabBar.dividerColor = nil
        pageTabBar.lineColor = Color.blue.lighten3
        
        pageTabBar.lineAlignment = .bottom
    }
}

extension AppPageTabBarController: PageTabBarControllerDelegate {
    func pageTabBarController(pageTabBarController: PageTabBarController, didTransitionTo viewController: UIViewController) {
        print("pageTabBarController", pageTabBarController, "didTransitionTo viewController:", viewController)
    }
}
