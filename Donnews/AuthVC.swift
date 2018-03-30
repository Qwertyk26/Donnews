//
//  AuthVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 29.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire
import MBProgressHUD

class AuthVC: UIViewController {
    
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        textField.isSecureTextEntry = true
        return textField
    }()
    let signUpBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: UIControlState.normal)
        button.setTitleColor(UIColor.dividerColor, for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "PTSans-Caption", size: 17)
        button.backgroundColor = UIColor.clear
        return button
    }()
    let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Вход", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.dividerColor
        button.titleLabel?.font = UIFont(name: "PTSans-Caption", size: 17)
        button.layer.cornerRadius = 5
        return button
    }()
    let closeButton: IconButton = {
        let closeButton = IconButton(image: Icon.close, tintColor: UIColor.white)
        return closeButton
    }()
    let vkBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_vk"), for: UIControlState.normal)
        button.layer.cornerRadius = 20
        button.tag = 0
        button.addTarget(self, action: #selector(socButtonsHandel(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    let fbBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_facebook"), for: UIControlState.normal)
        button.layer.cornerRadius = 20
        button.tag = 1
        button.addTarget(self, action: #selector(socButtonsHandel(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    let okBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_ok"), for: UIControlState.normal)
        button.layer.cornerRadius = 20
        button.tag = 2
        button.addTarget(self, action: #selector(socButtonsHandel(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    let twitterBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_twitter"), for: UIControlState.normal)
        button.layer.cornerRadius = 20
        button.tag = 3
        button.addTarget(self, action: #selector(socButtonsHandel(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    let buttonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpBtn)
        view.addSubview(loginBtn)
        view.addSubview(buttonsView)
        buttonsView.addSubview(vkBtn)
        buttonsView.addSubview(fbBtn)
        buttonsView.addSubview(twitterBtn)
        buttonsView.addSubview(okBtn)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: loginTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: passwordTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: signUpBtn)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: loginBtn)
        view.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: loginTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: buttonsView)
        view.addConstraintsWithFormat(format: "V:|[v0(64)]|", views: vkBtn)
        view.addConstraintsWithFormat(format: "V:|[v0(64)]|", views: fbBtn)
        view.addConstraintsWithFormat(format: "V:|[v0(64)]|", views: twitterBtn)
        view.addConstraintsWithFormat(format: "V:|[v0(64)]|", views: okBtn)
        
        buttonsView.addConstraintsWithFormat(format: "H:|-20-[v0(64)]-20-[v1(64)]-20-[v2(64)]-20-[v3(64)]-20-|", views: vkBtn, fbBtn, okBtn,twitterBtn)
        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginBtn.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 10).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true

        buttonsView.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 10).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        signUpBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationItem.titleLabel.text = "Авторизация"
        navigationItem.titleLabel.textColor = UIColor.white
        navigationItem.titleLabel.font = UIFont(name: "PTSans-Caption", size: 20)
        signUpBtn.addTarget(self, action: #selector(signUpHandle(_:)), for: UIControlEvents.touchUpInside)
        closeButton.addTarget(self, action: #selector(closeHandleButton(_:)), for: .touchUpInside)
        navigationItem.leftViews = [closeButton]
        loginBtn.addTarget(self, action: #selector(loginBtnHandle(_:)), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func signUpHandle(_ sender: UIButton) {
       navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    func closeHandleButton(_ sender: IconButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func socButtonsHandel(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let socAuthVC = SocAuthVC()
            socAuthVC.socType = "vk"
            navigationController?.pushViewController(socAuthVC, animated: true)
            break
        case 1:
            let socAuthVC = SocAuthVC()
            socAuthVC.socType = "fb"
            navigationController?.pushViewController(socAuthVC, animated: true)
            break
        case 2:
            let socAuthVC = SocAuthVC()
            socAuthVC.socType = "ok"
            navigationController?.pushViewController(socAuthVC, animated: true)
            break
        case 3:
            let socAuthVC = SocAuthVC()
            socAuthVC.socType = "tw"
            navigationController?.pushViewController(socAuthVC, animated: true)
            break
        default:
            break
        }
    }
    func loginBtnHandle(_ sender: UIButton) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Подождите..."
        progressHUD.show(animated: true)
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.Login?email=%@&password=%@", loginTextField.text!, passwordTextField.text!)).responseJSON { response in
            print("authResult \(response.response)")
            switch(response.result) {
            case .success(let JSON):
                progressHUD.hide(animated: true)
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as AnyObject
                let auth = result.value(forKey: "auth") as! Bool
                if (!auth) {
                    self.view.makeToast(message: result.value(forKey: "message") as! String)
                } else {
                    progressHUD.hide(animated: true)
                    let defaults = UserDefaults.standard
                    defaults.set(result.value(forKey: "username"), forKey: "name")
                    defaults.set(true, forKey: "auth")
                    defaults.set(result.value(forKey: "dn_token"), forKey: "dn_token")
                    self.navigationController?.dismiss(animated: true, completion: {
                        progressHUD.hide(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setMenuItem"), object: nil)
                    })
                }
                break
            case .failure(let error):
                progressHUD.hide(animated: true)
                self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                break
            }
        }
    }
}
