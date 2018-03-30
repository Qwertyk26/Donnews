//
//  NewCommentVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 29.05.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire
import MBProgressHUD

class NewCommentVC: UIViewController, UITextViewDelegate {
    var alias = String()
    let commetTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Оставить комментарий"
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "PTSans-Caption", size: 15)
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let leftBarButton = FlatButton(title: "Отпр.", titleColor: UIColor.white)
        leftBarButton.titleLabel?.font = UIFont(name: "PTSans-Caption", size: 17)
        leftBarButton.addTarget(self, action: #selector(sendComment(_:)), for: .touchUpInside)
        self.navigationItem.rightViews = [leftBarButton]
        view.addSubview(commetTextView)
        commetTextView.delegate = self
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: commetTextView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: commetTextView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sendComment(_ sender: UIBarButtonItem) {
        if (commetTextView.text.isEmpty || commetTextView.text.contains("Оставить комментарий")) {
            self.view.makeToast(message: "Введите текст комментария")
        } else {
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Подождите..."
            let dn_token = UserDefaults.standard.string(forKey: "dn_token")
            Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.addComment?alias=%@&text=%@&dn_token=%@", alias, commetTextView.text, dn_token!)).responseJSON { response in
                switch(response.result) {
                    case .success(let JSON):
                    progressHUD.hide(animated: true)
                    self.commetTextView.text = "Оставить комментарий"
                    self.commetTextView.endEditing(false)
                    self.commetTextView.textColor = UIColor.lightGray
                    self.view.makeToast(message: "Комментарий будет добавлен после проверки модератором")
                    break
                case .failure(let error):
                    progressHUD.hide(animated: true)
                    self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                    break
                }
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commetTextView.textColor == UIColor.lightGray {
            commetTextView.text = ""
            commetTextView.textColor = UIColor.black
        }
    }
}
