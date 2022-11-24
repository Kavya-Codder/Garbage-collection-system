//
//  UserFeedbackViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase

enum Feedbacklevel: String {
    case Exlent = "1"
    case Good = "2"
    case Average = "3"
    case Poor = "4"
    case none = "0"
}

class UserFeedbackViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtvTextView: UITextView!
    @IBOutlet weak var txtfTitle: UITextField!
    @IBOutlet weak var btnExlent: UIButton!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var btnAverage: UIButton!
    @IBOutlet weak var btnPoor: UIButton!
    
    var feedbackType: Feedbacklevel = .Exlent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "appPrimaryColour")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setStyle(textField: txtvTextView)
        setStyle(textField: txtfTitle)
        txtfTitle.setLeftPaddingPoints(10)
        btnExlent.isSelected = true
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height/2
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setStyle(textField: UIView) {
        textField.layer.cornerRadius = 20
         textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    
    @IBAction func btnexcelent(_ sender: UIButton) {
        self.resetButtons()
        sender.isSelected = true
        feedbackType = .Exlent
    }
    
    @IBAction func btnGood(_ sender: UIButton) {
        self.resetButtons()
        sender.isSelected = true
        feedbackType = .Good
    }
    
    @IBAction func btnAverage(_ sender: UIButton) {
        self.resetButtons()
        sender.isSelected = true
        feedbackType = .Average
    }
    
    @IBAction func btnPoor(_ sender: UIButton) {
        self.resetButtons()
        sender.isSelected = true
        feedbackType = .Poor
    }
     
    @IBAction func btnOnClickSubmit(_ sender: UIButton) {
        if (txtfTitle.text?.isEmpty ?? false) {
            self.ShowAlert(title: "", message: "Please enter feedback title", handler: nil)
        } else if (txtvTextView.text?.isEmpty ?? false) {
            self.ShowAlert(title: "", message: "Please enter feedback message", handler: nil)
        } else {
            addComplaint()
        }
     }
    
    func resetButtons()  {
        btnExlent.isSelected = false
        btnGood.isSelected = false
        btnAverage.isSelected = false
        btnPoor.isSelected = false
        self.feedbackType = .none
     }
    
    func addComplaint() {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.feedback)
        let chatRefrence = ref.childByAutoId()
        let userId = UserDefaults.standard.value(forKey: UserKeys.id.rawValue) as! String
        let userName = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as! String
        let paramValue:[AnyHashable : Any] = ["id":"\(UUID().uuidString)",
                                              "title": txtfTitle.text ?? "",
                                              "description": txtvTextView.text ?? "",
                                              "feedbackLevel": self.feedbackType.rawValue,
                                              "userId":userId,
                                              "userName":userName
                                                ]
        chatRefrence.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Thank You!", message: "Feedback added successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
                }
                } else {
                    print(error!)
                    return
                }
            }
        }
}
