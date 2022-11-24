//
//  UserDashboardViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 27/07/22.
//

import UIKit

class UserDashboardViewController: UIViewController {

    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addComplainsView: UIView!
    @IBOutlet weak var myComplainsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
   initialSetUp()
}
    func nevConfigration() {
        self.title = "Garbage Collector"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .white
    
    }
    override func viewWillAppear(_ animated: Bool) {
        nevConfigration()
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPushToMyComplainsScreen(_ sender: UIButton) {
        let myComplainsVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "MyComplainsViewController") as! MyComplainsViewController
        
        navigationController?.pushViewController(myComplainsVC, animated: true)
}
    
    @IBAction func onClickPushToAddComplainsScreen(_ sender: UIButton) {
        let addComplainsVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ComplainsViewController") as! ComplainsViewController
        navigationController?.pushViewController(addComplainsVC, animated: true)
        
}
    
    @IBAction func onClickPushToProfileScreen(_ sender: UIButton) {
        let profileVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(identifier: "UserProfileViewController") as! UserProfileViewController
        navigationController?.pushViewController(profileVC, animated: true)
}
    
    @IBAction func onClickPushToFeedbackScreen(_ sender: UIButton) {
        let feedbackVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserFeedbackViewController") as! UserFeedbackViewController
        navigationController?.pushViewController(feedbackVC, animated: true)
        
}
    func initialSetUp() {
        myComplainsView.layer.cornerRadius = 25
        addComplainsView.layer.cornerRadius = 25
        profileView.layer.cornerRadius = 25
        feedbackView.layer.cornerRadius = 25
    }

}
