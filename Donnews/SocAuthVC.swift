//
//  SocAuthVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 30.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import WebKit

class SocAuthVC: UIViewController, WKNavigationDelegate {
    
    var socType = String()
    var dn_token = String()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    var progressHUD = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.tintColor = UIColor.black
        progressHUD.label.text = "Подождите..."
        progressHUD.show(animated: true)
        webView.navigationDelegate = self
        Alamofire.request("http://www.donnews.ru/json/api.getToken").responseJSON { response in
            print("request \(response.result)")
            switch(response.result) {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as AnyObject
                self.dn_token = (result.value(forKey: "dn_token") as? String)!
                if (self.socType.contains("vk")) {
                    let url = URL(string: String.init(format: "http://oauth.vk.com/authorize?client_id=5361673&redirect_uri=http://donnews.ru/socauth/vk/?dn_token=%@&response_type=code&scope=email", self.dn_token))
                    let request = URLRequest(url: url!)
                    self.webView.load(request)
                } else if (self.socType.contains("fb")) {
                    let url = URL(string: String.init(format: "https://www.facebook.com/dialog/oauth?client_id=1587149864941791&redirect_uri=http://donnews.ru/socauth/fb/?dn_token=%@&response_type=code&scope=email", self.dn_token))
                    let request = URLRequest(url: url!)
                    self.webView.load(request)
                } else if (self.socType.contains("ok")) {
                    let url = URL(string: String.init(format: "https://www.odnoklassniki.ru/oauth/authorize?client_id=1246575872&redirect_uri=http://donnews.ru/socauth/ok/?dn_token=%@&response_type=code&scope=email", self.dn_token))
                    let request = URLRequest(url: url!)
                    self.webView.load(request)
                } else if (self.socType.contains("tw")) {
                    let url = URL(string: String.init(format: "http://donnews.ru/socauth/tw/?dn_token=%@", self.dn_token))
                    let request = URLRequest(url: url!)
                    self.webView.load(request)
                }
                break
            case .failure(let error):
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressHUD.hide(animated: true)
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        if (self.webView.url?.path.contains("/authorize_complete"))! {
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Подождите..."
            progressHUD.show(animated: true)
            webView.stopLoading()
            Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.soc_auth?dn_token=%@", self.dn_token)).responseJSON { response in
                switch(response.result) {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    let result = response.object(forKey: "result") as AnyObject
                    let defaults = UserDefaults.standard
                    defaults.set(result.value(forKey: "name"), forKey: "name")
                    defaults.set(true, forKey: "auth")
                    defaults.set(self.dn_token, forKey: "dn_token")
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.progressHUD.hide(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setMenuItem"), object: nil)
                    })
                    break
                case .failure(let error):
                    self.progressHUD.hide(animated: true)
                    self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                    break
                }
            }
        }
    }
}
