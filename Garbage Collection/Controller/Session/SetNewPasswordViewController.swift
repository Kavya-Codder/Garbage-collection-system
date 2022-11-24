//
//  SetNewPasswordViewController.swift
//  Garbage Collection
//
//  Created by Sunil Kumar on 16/10/2022.
//

import UIKit
import Firebase

class SetNewPasswordViewController: UIViewController {
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewConfirmPassword: UITextField!
    @IBOutlet weak var ViewLoginContainer: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var user:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initialSetUp()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if (txtNewPassword.text?.isEmpty ?? false) {
            self.ShowAlert(title:"", message: "Please enter new password", handler: nil)
        } else if (txtNewConfirmPassword.text?.isEmpty ?? false) {
            self.ShowAlert(title:"", message: "Please enter confirm password", handler: nil)
        }else if (txtNewPassword.text != txtNewConfirmPassword.text) {
            self.ShowAlert(title:"", message: "Password does not match", handler: nil)
        }else {
            updatePassword()
        }
    }
    func initialSetUp() {
        ViewLoginContainer.layer.cornerRadius = 30
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        setStyle(textField: txtNewPassword)
        setStyle(textField: txtNewConfirmPassword)
        txtNewConfirmPassword.setLeftPaddingPoints(40)
        txtNewPassword.setLeftPaddingPoints(40)
//        txtPassword.isSecureTextEntry = true
    }
    
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        textField.layer.borderWidth = 1
    }

    func updatePassword() {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList).child(user?.key ?? "")
        let paramValue:[AnyHashable : Any] = [
            "password":txtNewPassword.text ?? ""]
        ref.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.stopAnimating()
                self.displayAlert(with: "Success", message: "Password has been updated successfully", buttons: ["ok"]) { (str) in
                     self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                print(error!)
                return
            }
        }
    }
    
}
