//
//  SearchVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 24.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let cellId = "cellId"
    let storiesId = "storiesId"
    let otherId = "otherId"
    let specprojectsId = "specprojectsId"
    let interViewId = "interViewId"
    let authorColumnId = "authorColumnId"
    var loadingData = false
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    let closeButton: IconButton = {
        let closeButton = IconButton(image: Icon.close, tintColor: UIColor.white)
        return closeButton
    }()
    var pagingSpinner = UIActivityIndicatorView()
    var currentPage = 0
    var newsArray = [NewsEntity]()
    lazy var searchBars:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 70, height:20))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(StoriesTVC.self, forCellReuseIdentifier: storiesId)
        tableView.register(SpecprojectsTVC.self, forCellReuseIdentifier: specprojectsId)
        tableView.register(InterviewTVC.self, forCellReuseIdentifier: interViewId)
        tableView.register(OtherTVC.self, forCellReuseIdentifier: otherId)
        tableView.register(AuthorColumnTVC.self, forCellReuseIdentifier: authorColumnId)
        let emptyView = EmptyTabelView()
        emptyView.setTitle(title: "Здесь будут показаны результаты поиска")
        tableView.backgroundView = emptyView
        configureSearchController()
        navigationController?.navigationBar.backgroundColor = UIColor.toolBarColor
    }
    func configureSearchController() {
        searchBars.placeholder = "Поиск в Donnews"
        searchBars.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView: searchBars)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        navigationItem.rightViews = [closeButton]
        closeButton.addTarget(self, action: #selector(closeHandleButton(_:)), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: otherId, for: indexPath) as! OtherTVC
        cell.configureCell(item: newsArray[indexPath.item])
        cell.selectionStyle = .none
        if (newsArray[indexPath.item].category == .Stories) {
            let storiesCell = tableView.dequeueReusableCell(withIdentifier: storiesId, for: indexPath) as! StoriesTVC
            storiesCell.configureCell(item: newsArray[indexPath.item])
            storiesCell.selectionStyle = .none
            return storiesCell
        }
        else if (newsArray[indexPath.item].category == .AuthorColumn) {
            let authorColumnCell = tableView.dequeueReusableCell(withIdentifier: authorColumnId, for: indexPath) as! AuthorColumnTVC
            authorColumnCell.configureCell(item: newsArray[indexPath.item])
            return authorColumnCell
        } else if (newsArray[indexPath.item].category == .Specprojects) {
            let specprojectsCell = tableView.dequeueReusableCell(withIdentifier: specprojectsId, for: indexPath) as! SpecprojectsTVC
            specprojectsCell.configureCell(item: newsArray[indexPath.item])
            return specprojectsCell
        } else if (newsArray[indexPath.item].category == .InterView) {
            let interviewCell = tableView.dequeueReusableCell(withIdentifier: interViewId, for: indexPath) as! InterviewTVC
            interviewCell.configureCell(item: newsArray[indexPath.item])
            return cell
        }
        return cell
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.backgroundView = nil
        activityIndicator.startAnimating()
        searchBar.endEditing(true)
        let safeURL = searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getSearch?pattern=%@&offset=0&count=10", safeURL!)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.activityIndicator.stopAnimating()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as! [AnyObject]
                if (result.count == 0) {
                    let emptyView = EmptyTabelView()
                    emptyView.setTitle(title: "По вашему запросу \n ничего не найдено." )
                    self.tableView.backgroundView = emptyView
                } else {
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
                }
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
    func loadMore(offset: Int) {
        let safeURL = searchBars.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getSearch?pattern=%@&offset=%d&count=10", safeURL!, offset)).responseJSON { response in
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
                print("searchError \(error)")
                self.loadingData = false
                self.pagingSpinner.stopAnimating()
                self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                break
            }
        }
    }
    func closeHandleButton(_ sender: IconButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newsDetailVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! NewsDetailVC
        newsDetailVC.newsEntity = newsArray[indexPath.item]
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
}
