//
//  RightVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 26.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class RightMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.dividerColor
        return tableView
    }()
    var menuItems = ["Войти", "Реклама", "О проекте", "Оставить отзыв", "Резмер шрифта"]
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        defaults = UserDefaults.standard
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setMenuItem(_:)), name: NSNotification.Name(rawValue: "setMenuItem"), object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: 17)
        if (defaults.bool(forKey: "auth")) {
            menuItems[0] = defaults.string(forKey: "name")!
        }
        cell.textLabel?.text = menuItems[indexPath.item]
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: NSIndexPath) -> NSIndexPath? {
        if (indexPath.row == 0) {
            if (defaults.bool(forKey: "auth")) {
                return nil
            }
        }
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.item == 0) {
            let navigationVC = AppToolbarController(rootViewController: AuthVC())
            self.present(navigationVC, animated: true, completion: {
                self.navigationDrawerController?.closeRightView()
            })
        }
        if (indexPath.item == 1) {
            let navigationVC = AppToolbarController(rootViewController: AdvertVC())
            self.present(navigationVC, animated: true, completion: {
                self.navigationDrawerController?.closeRightView()
            })
        }
        if (indexPath.item == 2) {
            let navigationVC = AppToolbarController(rootViewController: AboutVC())
            self.present(navigationVC, animated: true, completion: {
                self.navigationDrawerController?.closeRightView()
            })
        }
        if (indexPath.item == 3) {
            UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/us/app/donnews/id1254300120?l=ru&ls=1&mt=8")!);
        }
        if (indexPath.item == 4) {
            let navigationVC = AppToolbarController(rootViewController: FontsSettingsVC())
            self.present(navigationVC, animated: true, completion: {
                self.navigationDrawerController?.closeRightView()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setMenuItem(_ notification: Notification) {
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        cell?.textLabel?.text = defaults.string(forKey: "name")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
}
