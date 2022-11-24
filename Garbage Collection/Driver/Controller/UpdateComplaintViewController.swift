//
//  UpdateComplaintViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase

enum UpdateComplaintValidatioN: String {
    case binID = "Please enter Bin ID"
    case area = "Please enter Area"
    case locality = "Please enter Locality"
    case city = "Please enter City"
    case assignDriver = "Please enter Assign Driver"
    case complaint = "Please enter Complaint"
    case status = "Please enter Status"
}

class UpdateComplaintViewController: UIViewController {
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtComplaint: UITextView!
    @IBOutlet weak var txtAssignDriver: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtLocality: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtBin: UITextField!
    
    var complainObj:ComplaintModel?
    var status = ["Pending", "In Progress", "Completed"]
    var statusPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Status PickerView
        statusPicker = UIPickerView()
        statusPicker.delegate = self
        statusPicker.dataSource = self
        txtStatus.inputView = statusPicker
        txtStatus.delegate = self
        
        initialSetUp()
        setComplaindetails()
    }
    
    func setComplaindetails()  {
        if let complain = self.complainObj {
            txtBin.text = complain.binID ?? ""
            txtArea.text = complain.area ?? ""
            txtLocality.text = complain.area ?? ""
            txtCity.text = complain.city ?? ""
            txtAssignDriver.text = (UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String) ?? ""
            txtComplaint.text = complain.complaint ?? ""
            switch complain.complainStatus ?? "" {
            case ComplainStatus.Pening.rawValue:
                txtStatus.text = "Pending"
            case ComplainStatus.Inprogress.rawValue:
                txtStatus.text = "In Progress"
            case ComplainStatus.Completed.rawValue:
                txtStatus.text = "Completed"
            default:
                break
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmitBtn(_ sender: UIButton) {
        let validation = doValidation()
        if validation.0{
            updateComplain()
        }else {
            self.ShowAlert(title: "", message: validation.1, handler: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initialSetUp(){
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        
        setStyle(textField: txtBin)
        setStyle(textField: txtArea)
        setStyle(textField: txtLocality)
        setStyle(textField: txtCity)
        setStyle(textField: txtAssignDriver)
        setStyle(textField: txtStatus)
        setStyle1(textView: txtComplaint)
        
        txtBin.setLeftPaddingPoints(10)
        txtArea.setLeftPaddingPoints(10)
        txtLocality.setLeftPaddingPoints(10)
        txtCity.setLeftPaddingPoints(10)
        txtAssignDriver.setLeftPaddingPoints(10)
        txtStatus.setLeftPaddingPoints(10)
    }
    func setStyle(textField: UITextField){
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        statusPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    func setStyle1(textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    func doValidation() -> (Bool,String) {
        
        if (txtBin.text?.isEmpty  ?? false)  {
            return (false,UpdateComplaintValidatioN.binID.rawValue)
        }else if (txtArea.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.area.rawValue)
        }
        else if (txtLocality.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.locality.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.city.rawValue)
        }
        else if (txtAssignDriver.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.assignDriver.rawValue)
        }
        else if (txtStatus.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.status.rawValue)
        }
        else if (txtComplaint.text?.isEmpty ?? false)  {
            return (false,UpdateComplaintValidatioN.complaint.rawValue)
        }
        return (true,"")
    }
}

//MARK:- PickerView Delegate and DataSource
extension UpdateComplaintViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
             txtStatus.inputView = statusPicker
     }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  status[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtStatus.text = status[row]
        self.view.endEditing(true)
    }
    
    func updateComplain()  {
        self.startAnimating()
        let ref = Database.database().reference().root.child(FirebaseDB.complains).child(self.complainObj?.key ?? "")
        var status = ""
        switch self.txtStatus.text ?? ""{
        case "Pending":
            status = "1"
        case "In Progress":
            status = "2"
        case"Completed":
            status = "3"
        default:
            break
        }
        let paramValue:[AnyHashable : Any] = [
            "complainStatus":status,
         ]
        ref.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Success", message: "Complain updated successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
                 }
            } else {
                print(error!)
                return
            }
        }
     }
}
