//
//  ComplaintsListViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit
import Firebase
class ComplaintsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var tableView: UITableView!
    var complaints:[ComplaintModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getComplaints()
//        self.title = "Complaints List"
//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "appPrimaryColour")
//
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsListTableViewCell", for: indexPath) as! ComplaintsListTableViewCell
        let obj = complaints[indexPath.row]
        cell.lblUserName.text = "User Name: \(obj.userName ?? "")"
        cell.lblBinID.text = "Bin Name: \(obj.assignBin ?? "")"
        cell.lblArea.text = "Area: \(obj.area ?? "")"
        cell.lblCity.text = "City: \(obj.city ?? "")"
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
        cell.lblComplaint.text = "Complaint: \(obj.complaint ?? "")"
        cell.selectionStyle = .none
        return cell
    }
    
    func getComplaints() {
        self.startAnimating()
        //self.bins.removeAll()
        let ref = Database.database().reference().child(FirebaseDB.complains)
        ref.observeSingleEvent(of: .value) { (dataSnapShot) in
            self.stopAnimating()
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.complaints.append(ComplaintModel(dic: dic, key: key))
                    }
                }
               // self.binsBackUp = self.bins
                 self.tableView.reloadData()
                }
            }
            
        }


}
