//
//  ForgotPasswordViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 13/07/22.
//

import UIKit
import Firebase
enum ForgotPasswordValidation: String {
    case email = "Please enter email"
    case validEmail = "Please enter valid email"
}

enum Credentialf: String {
    case Admin = "admin@gmail.com"
    case User = "user@gmail.com"
    case Driver = "driver@gmail.com"
}

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var forgotPasswordViewContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    
    @IBAction func btnBacktoLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickPushToOTPScreen(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
            forgotPassword()
        } else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
    }
    
    func initialSetUp() {
        forgotPasswordViewContainer.layer.cornerRadius = 30
        
        sendButton.layer.cornerRadius = 20
        sendButton.clipsToBounds = true
        setStyle(txtField: txtEmail)
        
    }
    func setStyle(txtField: UITextField) {
        txtField.layer.cornerRadius = 20
        txtField.clipsToBounds = true
        txtField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        txtField.layer.borderWidth = 1
    }
    func doValidation() -> (Bool,String)//0 = true/false, 1 = message
    {
        if (txtEmail.text?.isEmpty  ?? false)  {
            return (false,ForgotPasswordValidation.email.rawValue)
        } else if !self.isValidEmailAddress(txtEmail.text ?? "") {
            return (false,ForgotPasswordValidation.validEmail.rawValue)
        }
        return (true,"")
    }
    
    func forgotPassword() {
        self.startAnimation()
        var users: [UserModel] = []
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        ref.queryOrdered(byChild: "emai").queryEqual(toValue: self.txtEmail.text ?? "").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            self.stopAnimating()
            if let result = snapshot.value as? [String:[String:Any]] {
                result.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        users.append(UserModel(dic: dic, key: key))
                    }
                }
            }
            if users.isEmpty {
                self.ShowAlert(title:"", message: "Email does not exist Please try with another email", handler: nil)
            } else {
                self.updateOtp(key: users.first?.key ?? "",user: users.first)
            }
        })
    }
    
    func updateOtp(key:String,user: UserModel?) {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList).child(key)
        let otpValue = random()
        let paramValue:[AnyHashable : Any] = [
                                              "OTP":otpValue,
                                              ]
        ref.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.stopAnimating()
                self.displayAlert(with: "Success", message: "Otp has been sent successfully", buttons: ["ok"]) { (str) in
                    let sendOTPVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterOTPViewController") as!
                    EnterOTPViewController
                    sendOTPVC.otp = otpValue
                    sendOTPVC.user = user
                    sendOTPVC.email = self.txtEmail.text ?? ""
                    self.navigationController?.pushViewController(sendOTPVC , animated: true)
                }
            } else {
                print(error!)
                return
            }
        }
    }
    
    func random() -> String {
        var result = ""
        repeat {
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while result.count < 4 || Int(result)! < 1000
        print(result)
        return result
    }
}

 
