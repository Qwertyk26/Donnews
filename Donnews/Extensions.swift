//
//  Extensions.swift
//  Donnews
//
//  Created by Anton Nikitin on 25.04.17.
//  Copyright © 2017 Donnews. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
   open class var primaryColor: UIColor {
        return UIColor.init(red: 69/255, green: 69/255, blue: 68/255, alpha: 1)
    }
    open class var categoryColor: UIColor {
        return UIColor.init(red: 216/255, green: 88/255, blue: 71/255, alpha: 1)
    }
    open class var dividerColor: UIColor {
        return UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
    }
    open class var leadColor: UIColor {
        return UIColor.init(red: 111/255, green: 111/255, blue: 110/255, alpha: 1)
    }
    open class var pagerColor: UIColor {
        return UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
    }
    open class var authorColor: UIColor {
        return UIColor(red: 24/255, green: 24/255, blue: 23/255, alpha: 1)
    }
    open class var toolBarColor: UIColor {
        return UIColor(red: 227/255, green: 5/255, blue: 19/255, alpha: 1)
    }
    open class var commentsColor: UIColor {
        return UIColor(red: 126/255, green: 153/255, blue: 197/255, alpha: 1)
    }
}
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
extension UIImageView {
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
}
extension String {

    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    func toDate(dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self)
        {
            return date
        }
        print("Invalid arguments ! Returning Current Date . ")
        return Date()
    }
}
extension UIView {
    func borders(for edges:[UIRectEdge], width: CGFloat = 0.5, color: UIColor = .leadColor) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: v)
                    addConstraintsWithFormat(format: "V:|[v0(1)]|", views: v)
                }
            }
        }
    }
}
extension CGFloat {
    init?(_ str: String) {
        guard let float = Float(str) else { return nil }
        self = CGFloat(float)
    }
}
extension UIWebView {
    func resizeWebContent() {
        let contentSize = self.scrollView.contentSize
        let viewSize = self.bounds.size
        let zoomScale = viewSize.width/contentSize.width
        self.scrollView.minimumZoomScale = zoomScale
        self.scrollView.maximumZoomScale = zoomScale
        self.scrollView.zoomScale = zoomScale
    }
}
extension DateFormatter {
    
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if components.year! >= 2 {
            result = dateFormatter.string(from: from as Date)
        } else if components.year! >= 1 {
            if numericDates {
                result = dateFormatter.string(from: from as Date)
            } else {
                result = dateFormatter.string(from: from as Date)
            }
        } else if components.month! >= 2 {
            result = dateFormatter.string(from: from as Date)
        } else if components.month! >= 1 {
            if numericDates {
                result = dateFormatter.string(from: from as Date)
            } else {
                result = dateFormatter.string(from: from as Date)
            }
        } else if components.weekOfYear! >= 2 {
            result = dateFormatter.string(from: from as Date)
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = dateFormatter.string(from: from as Date)
            } else {
                result = dateFormatter.string(from: from as Date)
            }
        } else if components.day! >= 2 {
            result = dateFormatter.string(from: from as Date)
        } else if components.day! >= 1 {
            if numericDates {
                 result = dateFormatter.string(from: from as Date)
            } else {
                result = "Вчера"
            }
        } else if components.hour! >= 2 {
            result = dateFormatter.string(from: from as Date)
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 час назад"
            } else {
                result = "час назад"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) мин. назад"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 минуту назад"
            } else {
                result = "минуту назад"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!) сек. назаж"
        } else {
            result = "только что"
        }
        
        return result
    }
}
