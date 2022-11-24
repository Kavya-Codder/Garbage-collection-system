//
//  DriverComplaintsViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase
class DriverComplaintsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var complaints:[ComplaintModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        getComplaints()
    }
    
    @IBAction func onClickPushToComplaintScreen(_ sender: Any) {
        let complaintVC = UIStoryboard(name: "Driver", bundle: nil).instantiateViewController(withIdentifier: "UpdateComplaintViewController") as! UpdateComplaintViewController
        navigationController?.pushViewController(complaintVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverComplaintTableViewCell", for: indexPath) as! DriverComplaintTableViewCell
        let obj = complaints[indexPath.row]
        cell.lblBinID.text = "Bin Name: \(obj.assignBin ?? "")"
        cell.lbluserName.text = "User Name: \(obj.userName ?? "")"
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
        cell.lblDriverName.text = "Driver Name: \(obj.name ?? "")"
        cell.lblComplaint.text = "Complaint: \(obj.complaint ?? "")"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //my Complains
        let myComplainsVC = UIStoryboard(name: "Driver", bundle: nil).instantiateViewController(withIdentifier: "UpdateComplaintViewController") as! UpdateComplaintViewController
        myComplainsVC.complainObj = self.complaints[indexPath.row]
        navigationController?.pushViewController(myComplainsVC, animated: true)
    }
    func getComplaints() {
        self.startAnimating()
        self.complaints.removeAll()
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
                 self.tableView.reloadData()
                }
            }
            
        }

   

}
