//
//  FeedbackViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit
import Firebase
class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    var feedback:[FeedbackModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        getFeedback()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedback.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackTableViewCell", for: indexPath) as! FeedbackTableViewCell
        let obj = feedback[indexPath.row]
        cell.lblName.text = obj.userName ?? ""
        cell.lblFeedback.text = obj.title ?? ""
        cell.lblMessage.text = obj.description ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func getFeedback() {
        self.startAnimating()
        self.feedback.removeAll()
        let ref = Database.database().reference().child(FirebaseDB.feedback)
        ref.observeSingleEvent(of: .value) { (dataSnapShot) in
            self.stopAnimating()
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.feedback.append(FeedbackModel(dic: dic))
                    }
                }
                  self.tableView.reloadData()
                }
            }
            
        }

}
