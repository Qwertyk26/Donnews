//
//  NewsDetailVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 27.04.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire

class NewsDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dividerView: NSLayoutConstraint!
    @IBOutlet weak var leaveCommentBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: UIWebView!
    
    var newsEntity: NewsEntity!
    var shareRightButton: IconButton!
    var size = CGFloat()
    var comments = [CommentEntity]()
    var sortComments = [CommentEntity]()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)
        dividerView.constant = 0.5
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTVC.self, forCellReuseIdentifier: "cellId")
        navigationDrawerController?.isEnabled = false
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.getArticle?alias=%@", newsEntity.alias!)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as AnyObject
                let comments_array = result.value(forKey: "comments") as! [AnyObject]
                self.comments = [CommentEntity]()
                
                for commentEntity in comments_array {
                    let c_id = commentEntity.value(forKey: "id") as! Int
                    let author_name = commentEntity.value(forKey: "author_name") as! String
                    let comment_text = commentEntity.value(forKey: "text") as! String
                    let date = commentEntity.value(forKey: "date") as! String
                    let commentItem = CommentEntity(c_id: c_id, author_name: author_name, text: comment_text, date: date)
                    self.comments.append(commentItem)
                }
                self.sortComments = self.comments.sorted { $0.date! > $1.date! }
                let html = self.newsEntity.text!.replacingOccurrences(of: "{{voter}}", with: "")
                let defaults = UserDefaults.standard
                let fontSize = defaults.integer(forKey: "fontSize")
                if (fontSize == 0) {
                    if (self.newsEntity.category != .InterView) {
                    let path = Bundle.main.url(forResource: "news_detail18", withExtension: "css")
                    DispatchQueue.global(qos: .background).async {
                    self.webView.loadHTMLString(String.init(format: "<html><head><link href=\"news_detail18.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div class='category'><p>%@</p></div><p class='news_title'>%@</p><p class='news_lead'>%@</p><img src=\"%@\" />%@<p class='author'>%@</p><div class='divider' /></body></html>", (self.newsEntity.category_name)!,(self.newsEntity.title)!, (self.newsEntity.lead)!, (self.newsEntity.image_full)!, html, self.newsEntity.author_name!), baseURL: path)
                        }
                    } else {
                        let path = Bundle.main.url(forResource: "news_detail18", withExtension: "css")
                        DispatchQueue.global(qos: .background).async {
                            self.webView.loadHTMLString(String.init(format: "<html><head><link href=\"news_detail18.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div class='category'><p>%@</p></div><p class='news_title'>%@</p><p class='news_lead'>%@</p><img src=\"%@\" /><p class='expert_name'>%@</p><p class='expert_post'>%@</p>%@<div class='divider' /></body></html>", (self.newsEntity.category_name)!,(self.newsEntity.title)!, (self.newsEntity.lead)!, (self.newsEntity.image_full)!, self.newsEntity.expert_name!, self.newsEntity.expert_post!, html), baseURL: path)
                        }
                    }
                } else {
                    if (self.newsEntity.category != .InterView) {
                        let path = Bundle.main.url(forResource: String.init(format: "news_detail%d", fontSize), withExtension: "css")
                        DispatchQueue.global(qos: .background).async {
                            self.webView.loadHTMLString(String.init(format: "<html><head><link href=\"news_detail%d.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div class='category'><p>%@</p></div><p class='news_title'>%@</p><p class='news_lead'>%@</p><img src=\"%@\" />%@<p class='author'>%@</p><div class='divider' /></body></html>", fontSize, (self.newsEntity.category_name)!,(self.newsEntity.title)!, (self.newsEntity.lead)!, (self.newsEntity.image_full)!, html, self.newsEntity.author_name!), baseURL: path)
                        }
                    } else {
                        let path = Bundle.main.url(forResource: String.init(format: "news_detail%d", fontSize), withExtension: "css")
                        DispatchQueue.global(qos: .background).async {
                            self.webView.loadHTMLString(String.init(format: "<html><head><link href=\"news_detail%d.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div class='category'><p>%@</p></div><p class='news_title'>%@</p><p class='news_lead'>%@</p><img src=\"%@\" /><p class='expert_name'>%@</p><p class='expert_post'>%@</p>%@<div class='divider' /></body></html>", fontSize, (self.newsEntity.category_name)!,(self.newsEntity.title)!, (self.newsEntity.lead)!, (self.newsEntity.image_full)!, self.newsEntity.expert_name!, self.newsEntity.expert_post!, html), baseURL: path)
                        }
                    }
                }
                break
            case .failure(let error):
                print("commentserror \(error)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorConnection"), object: nil)
                break
            }
        }
        let shareBtn = IconButton(image: Icon.share, tintColor: UIColor.white)
        shareBtn.addTarget(self, action: #selector(shareButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        navigationItem.rightViews = [shareBtn]
        leaveCommentBtn.addTarget(self, action: #selector(handleLeaveCommentButton), for: UIControlEvents.touchUpInside)
        navigationController?.navigationBar.backgroundColor = UIColor.toolBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationDrawerController?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! CommentTVC
        cell.authorLabel.text = sortComments[indexPath.item].author_name
        cell.commentLabel.text = sortComments[indexPath.item].text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: sortComments[indexPath.item].date!)
        cell.dateLabel.text = dateFormatter.timeSince(from: date! as NSDate, numericDates: true)
        return cell
    }

    func shareButtonClicked(_ sender: UIButton) {
        var activityItems: [AnyObject]?
        let shareText = String.init(format: "%@\n%@%@", newsEntity.title!, "http://donnews.ru/", newsEntity.alias!)
        activityItems = [shareText as AnyObject]
        let activityController = UIActivityViewController(activityItems:
          activityItems!, applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        webView.stopLoading()
    }
   
    func handleLeaveCommentButton() {
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "auth")) {
            let newCommentsVC = NewCommentVC()
            newCommentsVC.alias = newsEntity.alias!
            self.navigationController?.pushViewController(newCommentsVC, animated: true)
        } else {
            let navigationVC = AppToolbarController(rootViewController: AuthVC())
            self.present(navigationVC, animated: true, completion: nil)
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let _size = CGFloat(webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")!)
        headerView.frame.size.height = _size!
        webViewHeight.constant = _size!
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked {
            if let url = request.url {
                UIApplication.shared.openURL(url)
                return false
            }
        }
        return true;
    }
}
