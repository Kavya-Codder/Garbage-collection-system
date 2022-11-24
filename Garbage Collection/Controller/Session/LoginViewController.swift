//
//  LoginViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 13/07/22.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    //shift+command+L
    //MARK:- ViewController's IBOutlet
    @IBOutlet weak var imageTop: UIImageView!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmailOrMobile: UITextField!
    @IBOutlet weak var ViewLoginContainer: UIView!
    @IBOutlet weak var imgEye: UIImageView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var btnEye: UIButton!
    //Validation Enum
    
    enum LoginValidation: String {
        case email = "Please enter email to login"
        case password = "Please enter password to login"
        case inCorrectLogin = "Please enter currect Email or Password"
    }

    enum Credential: String {
    case Admin = "admin@gmail.com"
    case User = "user@gmail.com"
    case Driver = "driver@gmail.com"
    }
    //MARK:- ViewController LifeCycle here -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        if UserDefaults.standard.value(forKey: UserKeys.isLoggedIn.rawValue) as? Bool ?? false {
            let userType = UserDefaults.standard.value(forKey: UserKeys.userType.rawValue) as? String
            switch (userType ?? "") {
            case "1":
                UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                let createBinVC = UIStoryboard(name:"User" , bundle: nil).instantiateViewController(withIdentifier: "UserHomeScreenViewController") as! UserHomeScreenViewController
                self.navigationController?.pushViewController(createBinVC, animated: true)
            case "2":
                UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                let createBinVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "AdminHomeScreenViewController") as! AdminHomeScreenViewController
                self.navigationController?.pushViewController(createBinVC, animated: false)
            case "3":
                UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                let createBinVC = UIStoryboard(name:"Driver" , bundle: nil).instantiateViewController(withIdentifier: "DriverHomeScreenViewController") as! DriverHomeScreenViewController
                self.navigationController?.pushViewController(createBinVC, animated: false)
            default:
                break
            }
        }
    }
    
    
    @IBAction func onclickForgotPassword(_ sender: Any) {
        let forgotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as!
        ForgotPasswordViewController
        navigationController?.pushViewController(forgotVC , animated: true)
    }
    
    @IBAction func onClickSigiUpButton(_ sender: Any) {
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpOptionViewController") as! SignUpOptionViewController
        navigationController?.pushViewController(signUpVC , animated: true)
    }
 
    @IBAction func btnShowPassword(_ sender: UIButton) {
        btnEye.isSelected =  !btnEye.isSelected
        if btnEye.isSelected {
             imgEye.image = UIImage(named: "visible_password")
        } else {
            imgEye.image = UIImage(named: "InvisiblePasswordIcon")
        }
         txtPassword.isSecureTextEntry = !btnEye.isSelected
    }
    
    @IBAction func onClickLoginButton(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
            getChatMessage()
        } else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
    }

    func initialSetUp() {
        ViewLoginContainer.layer.cornerRadius = 30
        buttonLogin.layer.cornerRadius = 20
        buttonLogin.clipsToBounds = true
        buttonSignUp.layer.cornerRadius = 20
        buttonSignUp.clipsToBounds = true
        setStyle(textField: txtEmailOrMobile)
        setStyle(textField: txtPassword)
        txtPassword.setLeftPaddingPoints(40)
        txtEmailOrMobile.setLeftPaddingPoints(40)
        txtPassword.isSecureTextEntry = true
    }
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        textField.layer.borderWidth = 1
    }
    
    func doValidation() -> (Bool,String)//0 = true/false, 1 = message
    {
        if (txtEmailOrMobile.text?.isEmpty  ?? false)  {
            return (false,LoginValidation.email.rawValue)
        }else if !self.isValidEmailAddress(txtEmailOrMobile.text ?? "")
        {
            return (false,ForgotPasswordValidation.validEmail.rawValue)
        }
        else if (txtPassword.text?.isEmpty ?? false)  {
            return (false,LoginValidation.password.rawValue)
        }else if (txtPassword.text?.isEmpty ?? false)  {
            return (false,LoginValidation.password.rawValue)
        }
        return (true,"")
    }


    func getChatMessage() {
        self.startAnimation()
        var users: [UserModel] = []
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        ref.queryOrdered(byChild: "emai").queryEqual(toValue: self.txtEmailOrMobile.text ?? "").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            self.stopAnimating()
            if let result = snapshot.value as? [String:[String:Any]] {
                result.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        users.append(UserModel(dic: dic, key: key))
                    }
                }
            }
            if users.isEmpty {
                self.ShowAlert(title: "", message: "Please enter correct email or password ", handler: nil)
            } else {
                if (users.first?.password ?? "") == (self.txtPassword.text ?? "") {
                    switch users.first?.userType {
                    case "1":
                        UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                        let createBinVC = UIStoryboard(name:"User" , bundle: nil).instantiateViewController(withIdentifier: "UserHomeScreenViewController") as! UserHomeScreenViewController
                        self.navigationController?.pushViewController(createBinVC, animated: true)
                    case "2":
                        UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                        let createBinVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "AdminHomeScreenViewController") as! AdminHomeScreenViewController
                        self.navigationController?.pushViewController(createBinVC, animated: false)
                    case "3":
                        UserDefaults.standard.set(true, forKey: UserKeys.isLoggedIn.rawValue)
                        let createBinVC = UIStoryboard(name:"Driver" , bundle: nil).instantiateViewController(withIdentifier: "DriverHomeScreenViewController") as! DriverHomeScreenViewController
                        self.navigationController?.pushViewController(createBinVC, animated: false)
                    case .none:
                        break
                    case .some(_):
                        break
                    }
                    UserDefaults.saveUserVales(user: users.first)
                } else {
                    self.ShowAlert(title: "", message: "Please enter correct password ", handler: nil)
                }
              
            }
        })
    }

}

