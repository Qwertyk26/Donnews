//
//  ViewController.swift
//  Donnews
//
//  Created by Anton Nikitin on 25.04.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController, ViewPagerControllerDataSource, ViewPagerControllerDelegate {
    var tabs = [
        ViewPagerTab(title: "Главная", image: nil),
        ViewPagerTab(title: "Новости", image: nil),
        ViewPagerTab(title: "Сюжеты", image: nil),
        ViewPagerTab(title: "Спецпроекты", image: nil),
        ViewPagerTab(title: "Интервью", image: nil),
        ViewPagerTab(title: "Авторская колонка", image: nil)
    ]
    var searchButton: IconButton!
    var menuButton: IconButton!
    var viewPager:ViewPagerController!
    var selectedItem: IndexPath!
    
    override func viewDidLoad() {
        let options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont(name: "PTSans-Caption", size: 17)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
        searchButton = IconButton(image: Icon.search)
        searchButton.tintColor = UIColor.white
        searchButton.addTarget(self, action: #selector(handleSearchButton), for: .touchUpInside)
        menuButton = IconButton(image: UIImage(named: "ic_menu_white"))
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        navigationItem.rightViews = [searchButton, menuButton]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showNewsDetail(_:)), name: NSNotification.Name(rawValue: "ShowDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showConnectionError(_:)), name: NSNotification.Name(rawValue: "ShowErrorConnection"), object: nil)
        self.navigationController?.navigationBar.backgroundColor = UIColor.toolBarColor
    }

    func showNewsDetail(_ notification: NSNotification) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newsDetailVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! NewsDetailVC
        newsDetailVC.newsEntity = notification.userInfo?["newsEntity"] as? NewsEntity
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    func showConnectionError(_ notification: NSNotification) {
        self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func handleSearchButton() {
        let navigationVC = AppToolbarController(rootViewController: SearchVC())
        self.present(navigationVC, animated: true, completion: nil)
    }
    func handleMenuButton() {
        navigationDrawerController?.toggleRightView()
        
    }
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        switch position {
        case 0:
            let vc = MixNewsVC()
            return vc
        case 1:
            let vc = MainNewsVC()
            return vc
        case 2:
            let vc = StoriesVC()
            return vc
        case 3:
            let vc = SpecprojectsVC()
            return vc
        case 4:
            let vc = InterviewVC()
            return vc
        case 5:
            let vc = AuthorColumnVC()
            return vc
        default:
            let vc = MainNewsVC()
            return vc
        }
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}

