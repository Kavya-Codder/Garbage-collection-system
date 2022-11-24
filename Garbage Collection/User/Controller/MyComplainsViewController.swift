//
//  MyComplainsViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase
class MyComplainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var complaints:[ComplaintModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        getComplaints()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyComplainsTableViewCell", for: indexPath) as! MyComplainsTableViewCell
        let obj = complaints[indexPath.row]
        cell.lblBinID.text = "Title: \(obj.name ?? "")"
        cell.lblArea.text = "Area: \(obj.area ?? "")"
        cell.lblCity.text = "City: \(obj.city ?? "")"
        cell.lblAssignBin.text = "Bin Name: \(obj.assignBin ?? "")"
        cell.lblComplaint.text = "Complaint: \(obj.complaint ?? "")"
        switch obj.complainStatus ?? "" {
        case ComplainStatus.Pening.rawValue:
            cell.lblStatus.text  = "Pending"
            cell.lblStatus.textColor = UIColor.red
            cell.lblStatus.layer.borderColor = UIColor.red.cgColor
        case ComplainStatus.Inprogress.rawValue:
            cell.lblStatus.text  = "In Progress"
            cell.lblStatus.textColor = UIColor.cyan
            cell.lblStatus.layer.borderColor = UIColor.cyan.cgColor
        case ComplainStatus.Completed.rawValue:
            cell.lblStatus.text  = "Completed"
            cell.lblStatus.textColor = UIColor.green
            cell.lblStatus.layer.borderColor = UIColor.green.cgColor
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getComplaints() {
        self.startAnimating()
        self.complaints.removeAll()
        let userId = UserDefaults.standard.value(forKey: UserKeys.id.rawValue) as? String
        let ref = Database.database().reference().child(FirebaseDB.complains)
        ref.queryOrdered(byChild: "userId").queryEqual(toValue:userId).observeSingleEvent(of: .value) { (dataSnapShot) in
            self.stopAnimating()
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.complaints.append(ComplaintModel(dic: dic, key: key))
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

}
