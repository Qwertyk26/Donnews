//
//  AppToolbarController.swift
//  Donnews
//
//  Created by Anton Nikitin on 30.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material

class AppToolbarController: NavigationController {
    var searchButton: IconButton!
    var menuButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        v.depthPreset = .none
        v.backgroundColor = UIColor.primaryColor
        v.backButtonImage = UIImage(named: "ic_arrow_back_white")
        searchButton = IconButton(image: Icon.search)
        searchButton.tintColor = UIColor.white
        searchButton.addTarget(self, action: #selector(handleSearchButton), for: .touchUpInside)
        menuButton = IconButton(image: UIImage(named: "ic_menu_white"))
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        self.navigationController?.navigationItem.rightViews = [searchButton, menuButton]
    }
    func handleSearchButton() {
        self.navigationController?.pushViewController(SearchVC(), animated: true)
    }
    func handleMenuButton() {
        navigationDrawerController?.toggleRightView()
    }
}


