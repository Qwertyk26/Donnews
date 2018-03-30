//
//  CustomUIWebView.swift
//  Donnews
//
//  Created by Anton Nikitin on 01.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit

class CustomUIWebView: UIWebView, UIWebViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.delegate = self
    }
    override func loadHTMLString(_ string: String, baseURL: URL?) {
        
        let s:String = "<html><head><title></title><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\" /><link rel=\"stylesheet\" href=\"\" ></link></head><body>"+string+"</body></html>";
        var url:URL
        
        if baseURL == nil {
            url = Bundle.main.bundleURL as URL
        } else {
            url = baseURL!
        }
        
        super.loadHTMLString(s, baseURL: url)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewResizeToContent(webView: webView)
    }
    
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        
        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        let height:CGFloat = webView.scrollView.contentSize.height
        print("UIWebView.height: \(height)")
        
        webView.frame.size.height = height
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: height)
        webView.addConstraint(heightConstraint)
        
        // Set layout flag
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
    }
}
