//
//  EnterOTPViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 13/07/22.
//

import UIKit
import Firebase
enum OTPValidation: String {
    case txt = "Please enter OTP"
    case inCorrectLogin = "Please enter currect OTP"
}
class EnterOTPViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var viewOTPContainer: UIView!
    @IBOutlet weak var buttonVerify: UIButton!
    var otp = ""
    var email: String = ""
    var user:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initialSetUpOTPScreen()
     }
    
    @IBAction func onClickVerifyButton(_ sender: Any) {
        let validation = dovalidation()
        if validation.0 {
            if !(txt1.text?.isEmpty ?? true) && !(txt2.text?.isEmpty ?? true) && !(txt3.text?.isEmpty ?? true) && !(txt4.text?.isEmpty ?? true) {
//                 let forgotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as!
//                    LoginViewController
//                navigationController?.pushViewController(forgotVC , animated: true)
                checkOTp()
             }
        }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
        
    }
    
    func initialSetUpOTPScreen() {
        viewOTPContainer.layer.cornerRadius = 30
        buttonVerify .layer.cornerRadius = 15
        buttonVerify.clipsToBounds = true
        txt1.delegate = self
        txt2.delegate = self
        txt3.delegate = self
        txt4.delegate = self
        setStyle(txtField: txt1)
        setStyle(txtField: txt2)
        setStyle(txtField: txt3)
        setStyle(txtField: txt4)
        if !otp.isEmpty {
            let otps = otp.digits
            if otps.count == 4 {
                txt1.text = "\(otps[0])"
                txt2.text = "\(otps[1])"
                txt3.text = "\(otps[2])"
                txt4.text = "\(otps[3])"
            }
        }
        //To move cursor on next text field for OTP
        [txt1, txt2, txt3, txt4].forEach {
            $0?.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
    }
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField{
            case txt1:
                txt1.becomeFirstResponder()
            case txt2:
                txt1.becomeFirstResponder()
            case txt3:
                txt2.becomeFirstResponder()
            case txt4:
                txt3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func setStyle(txtField: UITextField) {
        txtField.layer.cornerRadius = 8
        txtField.clipsToBounds = true
        txtField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        txtField.layer.borderWidth = 1
    }
    
    func dovalidation() -> (Bool,String) {
        if (txt1.text?.isEmpty  ?? false) {
            return(false,OTPValidation.txt.rawValue)
        }
        else if (txt2.text?.isEmpty ?? false){
            return (false,OTPValidation.txt.rawValue)
        }
        else if (txt3.text?.isEmpty ?? false){
            return(false,OTPValidation.txt.rawValue)
        }
        else if (txt4.text?.isEmpty ?? false) {
            return(false,OTPValidation.txt.rawValue)
        }
        return (true,"")
    }
    
    func checkOTp() {
        self.startAnimation()
        var users: [UserModel] = []
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        ref.queryOrdered(byChild: "emai").queryEqual(toValue:self.email).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
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
                if users.first?.OTP == self.otp {
                    let setPasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetNewPasswordViewController") as!
                    SetNewPasswordViewController
                    setPasswordVC.user = self.user
                    self.navigationController?.pushViewController(setPasswordVC , animated: true)
                }
             }
        })
    }
    
}
// MARK: - TextField Delegate Methods
extension EnterOTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText: String = text.replacingCharacters(in: textRange, with: string)
            return updatedText.count <= 1
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
