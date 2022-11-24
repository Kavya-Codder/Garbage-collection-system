//
//  SignUpOptionViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 13/07/22.
//

import UIKit

class SignUpOptionViewController: UIViewController {

    @IBOutlet weak var buttonSingUpForUser: UIButton!
    @IBOutlet weak var buttonSignUpForAdmin: UIButton!
    @IBOutlet weak var viewSignUpContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        signUpInitialSetUp()
        
    }
    

    @IBAction func onClickPushToAdminSignUpScreen(_ sender: Any) {
        let adminRegisterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as!
            RegisterViewController
        adminRegisterVC.userType = .Admin
        navigationController?.pushViewController(adminRegisterVC , animated: true)
    }
    

    @IBAction func onClickPushToUserSignUpScreen(_ sender: Any) {
        let userRegisterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as!
            RegisterViewController
        userRegisterVC.userType = .User
        navigationController?.pushViewController(userRegisterVC , animated: true)
    }
    func signUpInitialSetUp(){
        viewSignUpContainer.layer.cornerRadius = 30
        
        buttonSignUpForAdmin.layer.cornerRadius = 20
        buttonSignUpForAdmin.clipsToBounds = true
        
        buttonSingUpForUser.layer.cornerRadius = 20
        buttonSingUpForUser.clipsToBounds = true
    }
}
