//
//  LogoutViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 23/07/22.
//

import UIKit

class LogoutViewController: UIViewController {

    @IBOutlet weak var logoutViewContainer: UIView!
    @IBOutlet weak var buttonLogOut: UIButton!
    @IBOutlet weak var buttonCancle: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetUpLogOutScreen()
    }
    
    
    @IBAction func onClickLogOutBtn(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginViewController {
                UserDefaults.standard.set(false, forKey: UserKeys.isLoggedIn.rawValue)
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func onClickCancleBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LeftMenuViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    
    func initialSetUpLogOutScreen() {
        logoutViewContainer.layer.cornerRadius = 30
        
        buttonLogOut.layer.cornerRadius = 20
        buttonLogOut.clipsToBounds = true
        
        buttonCancle.layer.cornerRadius = 20
        buttonCancle.clipsToBounds = true
    }
   

}
