//
//  LeftMenuViewController.swift
//  POCLeftMenu
//
//  Created by Yash on 01/08/22.
//

import UIKit

protocol MemuBackDelegate: AnyObject {
    func back()
}

class LeftMenuViewController: UIViewController {


    
    @IBOutlet weak var txtLogout: UITextField!
    @IBOutlet weak var txtAbout: UITextField!
    @IBOutlet weak var txtHome: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var rightBlurView: UIView!
     @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var menuBackDelegate: MemuBackDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        txtLogout.layer.cornerRadius = txtLogout.frame.height/2
        txtAbout.layer.cornerRadius = txtAbout.frame.height/2
        txtHome.layer.cornerRadius = txtHome.frame.height/2
        if let name = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String {
            lblUserName.text = name.capitalized
        }
        if let city = UserDefaults.standard.value(forKey: UserKeys.city.rawValue) as? String {
            lblCity.text = city
        }
    }

    @IBAction func onClickLogOutBtn(_ sender: Any) {
        let loguotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
        navigationController?.pushViewController(loguotVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }


    @IBAction func onTappedRightDismissButton(_ sender: UIButton) {
        /* let nav = self.navigationController
         DispatchQueue.main.async {
         nav?.view.layer.add(CATransition().popFromLeft(), forKey: nil)
         self.navigationController?.popViewController(animated: true)
         }*/

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.frame.origin.x = -self.view.bounds.size.width
            self.menuBackDelegate?.back()
        }, completion: { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }

    @IBAction func onClcikAboutUs(_ sender: Any) {
        let loguotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutScreenViewController") as! AboutScreenViewController
        navigationController?.pushViewController(loguotVC, animated: true)
    }
}
