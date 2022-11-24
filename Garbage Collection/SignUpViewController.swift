//
//  SignUpViewController.swift
//  Garbage Collection
//
//  Created by Sunil Developer on 11/07/22.
//

import UIKit

class SignUpViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
}
    
    @IBAction func signUpForAdmin(_ sender: Any) {
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")as!
            RegisterViewController
    //present
    
    present(registerVC, animated: true, completion: nil) 
    }
   

}
