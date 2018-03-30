//
//  AuthorColumnCell.swift
//  Donnews
//
//  Created by Anton Nikitin on 30.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Alamofire

class AuthorColumnVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentPage = 0
    var newsArray = [NewsEntity]()
    var loadingData = false
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicatorView.startAnimating()
        return indicatorView
    }()
    let cellId = "authotColumnId"
    var pagingSpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(AuthorColumnTVC.self, forCellReuseIdentifier: cellId)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        fetchResult()
    }
   
    func fetchResult() {
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticleList?offset=%d&count=10&category=authorcolumn", currentPage)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.activityIndicator.stopAnimating()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    let newsItem = NewsEntity(alias: alias!, category: .AuthorColumn, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                    self.newsArray.append(newsItem)
                }
                self.tableView.reloadData()
                break
            case .failure(let error):
                let emptyView = EmptyTabelView()
                emptyView.setTitle(title: "Произошла ошибка при загрузке данных. \n Проыерьте интернет соединение." )
                self.tableView.backgroundView = emptyView
                self.activityIndicator.stopAnimating()
                break
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if (!self.loadingData) {
                self.loadingData = true
                self.currentPage += 11
                loadMore(offset: currentPage)
                let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 34))
                pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                pagingSpinner.startAnimating()
                pagingSpinner.hidesWhenStopped = true
                footer.addSubview(pagingSpinner)
                footer.addConstraintsWithFormat(format: "H:|[v0]|", views: pagingSpinner)
                footer.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: pagingSpinner)
                tableView.tableFooterView = footer
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AuthorColumnTVC
        cell.selectionStyle = .none
        cell.configureCell(item: newsArray[indexPath.item])
    return  cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userInfo = [String: NewsEntity]()
        userInfo["newsEntity"] = newsArray[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDetail"), object: nil, userInfo: userInfo)
    }
    func loadMore(offset: Int) {
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticleList?offset=%d&count=10&category=authorcolumn", offset)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    let newsItem = NewsEntity(alias: alias!, category: .AuthorColumn, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                    self.newsArray.append(newsItem)
                }
                self.tableView.reloadData()
                self.loadingData = false
                break
            case .failure(let error):
                self.loadingData = false
                self.pagingSpinner.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorConnection"), object: nil)
                break
            }
        }
    }

    func refresh() {
        currentPage = 0
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticleList?offset=%d&count=10&category=authorcolumn", currentPage)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.newsArray.removeAll()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    let newsItem = NewsEntity(alias: alias!, category: .AuthorColumn, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                    self.newsArray.append(newsItem)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                break
            case .failure(let error):
                self.refreshControl.endRefreshing()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorConnection"), object: nil)
                break
            }
        }
    }
}
