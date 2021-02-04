//
//  Extensions.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit


//MARK: UIColor
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

//MARK: CALayer
extension UIView {
    
    func applyShadow(radius: CGFloat = 3.0, x: CGFloat = 0, y: CGFloat = 0, color: UIColor = .lightGray) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = radius
    }
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

//MARK: UIViewController
extension UIViewController {
    
    func showInfoAlert(title: String = "", message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
