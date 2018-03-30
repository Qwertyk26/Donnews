//
//  FontsSettingsVC.swift
//  Donnews
//
//  Created by Anton Nikitin on 02.06.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import UIKit
import Material

class FontsSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fontSizeSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 4
        slider.value = 2
        slider.minimumValue = 0
        return slider
    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        return tableView
    }()
    let closeButton: IconButton = {
        let closeButton = IconButton(image: Icon.close, tintColor: UIColor.white)
        return closeButton
    }()
    var defaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(fontSizeSlider)
        view.addSubview(tableView)
        navigationItem.title = "Размер текста"
        navigationItem.titleLabel.font = UIFont(name: "PTSans-Caption", size: 17)
        navigationItem.titleLabel.textColor = UIColor.white
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: fontSizeSlider)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]-10-[v1]-10-|", views: tableView, fontSizeSlider)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        fontSizeSlider.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        closeButton.addTarget(self, action: #selector(closeHandleButton(_:)), for: .touchUpInside)
        navigationItem.leftViews = [closeButton]
        fontSizeSlider.addTarget(self, action: #selector(sliderChangeHandle(_:)), for: UIControlEvents.valueChanged)
        defaults = UserDefaults.standard
        let fontSize = defaults.integer(forKey: "fontSize")
        switch fontSize {
        case 16:
            fontSizeSlider.setValue(0, animated: false)
            break
        case 17:
            fontSizeSlider.setValue(1, animated: false)
            break
        case 18:
            fontSizeSlider.setValue(2, animated: false)
            break
        case 19:
            fontSizeSlider.setValue(3, animated: false)
            break
        case 20:
            fontSizeSlider.setValue(4, animated: false)
            break
        default:
            fontSizeSlider.setValue(2, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Размер текста новости"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        cell.textLabel?.text = "Общественности представили эскизный проект реставрации парка культуры и отдыха имени Анатолия Собино в ЗЖМ. О концепции развития парка рассказал собравшимся руководитель архитектурного бюро «Проект» и автор рабочего эскиза Анатолий Мосин."
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        let fontSize = defaults.integer(forKey: "fontSize")
        switch fontSize {
            case 16:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: CGFloat(fontSize))
                break
            case 17:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: CGFloat(fontSize))
                break
            case 18:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: CGFloat(fontSize))
                break
            case 19:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: CGFloat(fontSize))
                break
            case 20:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: CGFloat(fontSize))
                break
            default:
                cell.textLabel?.font = UIFont(name: "PTSans-Caption", size: 18)
            }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func closeHandleButton(_ sender: IconButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func sliderChangeHandle(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        switch roundedValue {
        case 0:
            defaults.set(16, forKey: "fontSize")
            tableView.reloadData()
            break
        case 1:
            defaults.set(17, forKey: "fontSize")
            tableView.reloadData()
            break
        case 2:
            defaults.set(18, forKey: "fontSize")
            tableView.reloadData()
            break
        case 3:
            defaults.set(19, forKey: "fontSize")
            tableView.reloadData()
            break
        case 4:
            defaults.set(20, forKey: "fontSize")
            tableView.reloadData()
            break
        default:
            break
        }
    }
}
