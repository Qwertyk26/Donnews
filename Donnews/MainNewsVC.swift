//
//  MainNewsCell.swift
//  Donnews
//
//  Created by Anton Nikitin on 25.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MainNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    let firstNewsId = "firstNewsId"
    let otherId = "otherId"
    var loadingData = false
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        return tb
    }()
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    var pagingSpinner = UIActivityIndicatorView()
    var currentPage = 0
    var newsArray = [NewsEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(pagingSpinner)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(FirstNewsTVC.self, forCellReuseIdentifier: firstNewsId)
        tableView.register(OtherTVC.self, forCellReuseIdentifier: otherId)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)
        fetchResult()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: otherId, for: indexPath) as! OtherTVC
        cell.configureCell(item: newsArray[indexPath.item])
        cell.selectionStyle = .none
        if (indexPath.item == 0) {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: firstNewsId, for: indexPath) as! FirstNewsTVC
            firstCell.selectionStyle = .none
            firstCell.configureCell(item: newsArray[indexPath.item])
            return firstCell
        }
        return cell
    }
   
    func fetchResult() {
        Alamofire.request("http://www.donnews.ru/json/api.getArticleList?offset=0&count=10&category=main").responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.activityIndicator.stopAnimating()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text_full") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category = resultItems.value(forKey: "category") as! String
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let expert_name = resultItems.value(forKey: "expert_name") as? String
                    let expert_post = resultItems.value(forKey: "expert_post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    if (category.contains("interview")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: expert_name!, expert_post: expert_post!, author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("stories")) {
                        let newsItem = NewsEntity(alias: alias!, category: .Stories, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("authorcolumn")) {
                        let newsItem = NewsEntity(alias: alias!, category: .AuthorColumn, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("specproects")) {
                        let newsItem = NewsEntity(alias: alias!, category: .Specprojects, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else {
                        let newsItem = NewsEntity(alias: alias!, category: .Other, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    }
                }
                self.tableView.reloadData()
                break
            case .failure(let error):
                let emptyView = EmptyTabelView()
                emptyView.setTitle(title: "Произошла ошибка при загрузке данных. \n Проверьте интернет соединение." )
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
    func loadMore(offset: Int) {
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticleList?offset=%d&count=10&category=main", offset)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text_full") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category = resultItems.value(forKey: "category") as! String
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let expert_name = resultItems.value(forKey: "expert_name") as? String
                    let expert_post = resultItems.value(forKey: "expert_post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    if (category.contains("interview")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: expert_name!, expert_post: expert_post!, author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("stories")) {
                        let newsItem = NewsEntity(alias: alias!, category: .Stories, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("authorcolumn")) {
                        let newsItem = NewsEntity(alias: alias!, category: .AuthorColumn, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("specproects")) {
                        let newsItem = NewsEntity(alias: alias!, category: .Specprojects, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else {
                        let newsItem = NewsEntity(alias: alias!, category: .Other, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    }
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
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticleList?offset=0&count=10&category=main", currentPage)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.newsArray.removeAll()
                self.activityIndicator.stopAnimating()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                for resultItems in result {
                    let alias = resultItems.value(forKey: "alias") as? String
                    let lead = resultItems.value(forKey: "lead") as? String
                    let text = resultItems.value(forKey: "text_full") as? String
                    let image_full = resultItems.value(forKey: "image_full") as? String
                    let title = resultItems.value(forKey: "title") as? String
                    let image_width = resultItems.value(forKey: "image_width") as? CGFloat
                    let image_height = resultItems.value(forKey: "image_height") as? CGFloat
                    let category = resultItems.value(forKey: "category") as! String
                    let category_name = resultItems.value(forKey: "category_name") as? String
                    let comments_count = resultItems.value(forKey: "comments_count") as? Int
                    let date = resultItems.value(forKey: "date") as? String
                    let post = resultItems.value(forKey: "post") as? String
                    let expert_name = resultItems.value(forKey: "expert_name") as? String
                    let expert_post = resultItems.value(forKey: "expert_post") as? String
                    let author_name = resultItems.value(forKey: "author_name") as? String
                    if (category.contains("interview")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: expert_name!, expert_post: expert_post!, author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("stories")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("authorcolumn")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else if (category.contains("specproects")) {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: post!, expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    } else {
                        let newsItem = NewsEntity(alias: alias!, category: .InterView, title: title!, text: text!, lead: lead!, image_full: image_full!, image_width: image_width!, image_height: image_height!, category_name: category_name!, comments_count: comments_count!, date: date!, post: "", expert_name: "", expert_post: "", author_name: author_name!)
                        self.newsArray.append(newsItem)
                    }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userInfo = [String: NewsEntity]()
        userInfo["newsEntity"] = newsArray[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDetail"), object: nil, userInfo: userInfo)
    }
}
