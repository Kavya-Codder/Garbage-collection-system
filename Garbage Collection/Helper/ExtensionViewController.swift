//
//  ExtensionViewController.swift
//  Garbage Collection
//
//  Created by Sunil Kumar on 06/08/2022.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let Alert = "Alert!!!"
extension UIViewController: NVActivityIndicatorViewable  {

    func startAnimation() {
        startAnimating(type: .circleStrokeSpin)
    }
    
    func ShowAlert(title: String, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(action)
        // busy(on: false)
        self.present(alertController, animated: true)
    }
    
    func AlertViewConfirm(title: String, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: handler)
        alertController.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    func displayAlert(with title: String?, message: String?, buttons: [String], buttonStyles: [UIAlertAction.Style] = [], handler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        for i in 0 ..< buttons.count {
            let style: UIAlertAction.Style = buttonStyles.indices.contains(i) ? buttonStyles[i] : .default
            let buttonTitle = buttons[i]
            let action = UIAlertAction(title: buttonTitle, style: style) { (_) in
                handler(buttonTitle)
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController {
    // MARK: - Email Validations
     func isValidEmailAddress(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
