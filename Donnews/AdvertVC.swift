//
//  AdvertVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 31.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire

class AdvertVC: UIViewController, UIWebViewDelegate {
    
    let webView: UIWebView = {
        let webView = UIWebView()
        webView.isUserInteractionEnabled = true
        return webView
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)
        view.backgroundColor = UIColor.white
        activityIndicator.startAnimating()
        closeButton.addTarget(self, action: #selector(closeHandleButton(_:)), for: .touchUpInside)
        navigationItem.leftViews = [closeButton]
        webView.delegate = self
        let path = Bundle.main.url(forResource: "about", withExtension: "css")
        Alamofire.request("http://www.donnews.ru/json/api.Advert").responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                self.activityIndicator.stopAnimating()
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as AnyObject
                self.webView.loadHTMLString(String.init(format: "<html><head><link href=\"about.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body>%@</body></html>", result.value(forKey: "ad") as! String), baseURL: path)
                break
            case .failure(let error):
                self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                break
            }
        }
        navigationController?.navigationBar.backgroundColor = UIColor.toolBarColor
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.primaryColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func closeHandleButton(_ sender: IconButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
