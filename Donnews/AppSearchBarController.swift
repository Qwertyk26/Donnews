//
//  AppSearchBarController.swift
//  Donnews
//
//  Created by Anton Nikitin on 31.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material

class AppSearchBarController: SearchBarController {
    
    let closeButton: IconButton = {
        let closeButton = IconButton(image: Icon.close, tintColor: UIColor.primaryColor)
        closeButton.addTarget(self, action: #selector(closeHandelButton(_:)), for: .touchUpInside)
        return closeButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.leftViews = [closeButton]
    }

    func closeHandelButton(_ sender: IconButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
