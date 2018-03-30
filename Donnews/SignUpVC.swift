//
//  SignUpVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 29.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material
import Alamofire
import MBProgressHUD

class SignUpVC: UIViewController {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        return textField
    }()
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Логин"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        return textField
    }()
    let passwordRepeatTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Подтвердить пароль"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "PTSans-Caption", size: 17)
        return textField
    }()
    let signUpBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.dividerColor
        button.titleLabel?.font = UIFont(name: "PTSans-Caption", size: 17)
        button.layer.cornerRadius = 5
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.titleLabel.text = "Регистрация"
        navigationItem.titleLabel.textColor = UIColor.white
        navigationItem.titleLabel.font = UIFont(name: "PTSans-Caption", size: 20)
        view.addSubview(emailTextField)
        view.addSubview(loginTextField)
        view.addSubview(signUpBtn)
        view.addSubview(passwordRepeatTextField)
        view.addSubview(passwordTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: emailTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: loginTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: passwordTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: passwordRepeatTextField)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: signUpBtn)
        view.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: emailTextField)
        loginTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordRepeatTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        passwordRepeatTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: passwordRepeatTextField.bottomAnchor, constant: 10).isActive = true
        signUpBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpBtn.addTarget(self, action: #selector(signUpHadle(_:)), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func signUpHadle(_ sender: UIButton) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Подождите..."
        progressHUD.show(animated: true)
        Alamofire.request(String.init(format: "http://www.donnews.ru/json/api.registration?email=%@&username=%@&password1=%@&password2=%@", emailTextField.text!, loginTextField.text!, passwordTextField.text!, passwordRepeatTextField.text!)).responseJSON { response in
            switch(response.result) {
            case .success(let JSON):
                progressHUD.hide(animated: true)
                let response = JSON as! NSDictionary
                let result = response.object(forKey: "result") as AnyObject
                self.view.makeToast(message: result.value(forKey: "message") as! String)
                progressHUD.hide(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
                break
            case .failure(let error):
                progressHUD.hide(animated: true)
                self.view.makeToast(message: "Ошибка загрузки данных \n проверьте интернет соединение")
                break
            }
        }
    }
}
