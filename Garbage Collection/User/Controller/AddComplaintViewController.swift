//
//  AddComplaintViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase
enum AddComplaintValidation: String {
    case name = "Please enter name"
    case binID = "Please enter Bin ID"
    case area = "Please enter Area"
    case locality = "Please enter Locality"
    case city = "Please enter city"
    case assignBin = "Please enter Bin"
    case complaint = "Please enter Complaint"
}

enum ComplainStatus: String, CaseIterable {
    case Pening = "1"
    case Inprogress = "2"
    case Completed = "3"
}

class AddComplaintViewController: UIViewController {

    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var txtComplaint: UITextView!
    @IBOutlet weak var txtAssignBin: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtLocality: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtBinID: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    var binPicker: UIPickerView!
    var bins:[BinModel] = []
    var selectedBin: BinModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Bin PickerView
        binPicker = UIPickerView()
        binPicker.delegate = self
        binPicker.dataSource = self
        txtAssignBin.inputView = binPicker
        txtAssignBin.delegate = self
        initialSetUp()
        getbins()
}
   
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmitBtn(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
           addComplaint()
        }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
}
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func initialSetUp() {
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        setStyle(textField: txtBinID)
        setStyle(textField: txtName)
        setStyle(textField: txtArea)
        setStyle(textField: txtLocality)
        setStyle(textField: txtCity)
        setStyle(textField: txtAssignBin)
        setStyle1(textView: txtComplaint)
        
        txtName.setLeftPaddingPoints(10)
        txtArea.setLeftPaddingPoints(10)
        txtLocality.setLeftPaddingPoints(10)
        txtCity.setLeftPaddingPoints(10)
        txtAssignBin.setLeftPaddingPoints(10)
        
    }
    func setStyle(textField : UITextField){
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    func setStyle1(textView : UITextView){
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    func doValidation() -> (Bool,String)//0 = true/false, 1 = message
       {
        if (txtBinID.text?.isEmpty  ?? false)  {
            return (false,"Please enter title")
        }else if (txtArea.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.area.rawValue)
        }
        else if (txtName.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.name.rawValue)
        }
        else if (txtLocality.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.locality.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.city.rawValue)
        }
        else if (txtAssignBin.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.assignBin.rawValue)
        }
        else if (txtComplaint.text?.isEmpty ?? false)  {
            return (false,AddComplaintValidation.complaint.rawValue)
        }
        return (true,"")
    }
}
//MARK:- PickerView Delegate and DataSource
extension AddComplaintViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
            txtAssignBin.inputView = binPicker
       
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return bins.count
    
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bins[row].binID ?? ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtAssignBin.text = bins[row].binID ?? ""
        txtBinID.text = bins[row].id ?? ""
        self.selectedBin = bins[row]
    self.view.endEditing(true)
        
    }
}


//Firebase Utilities from here
extension AddComplaintViewController {
    func addComplaint() {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.complains)
        let chatRefrence = ref.childByAutoId()
        let idKyes = UserDefaults.standard.value(forKey: UserKeys.id.rawValue) as! String
        let userNme = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as! String
        let paramValue:[AnyHashable : Any] = ["id":"\(UUID().uuidString)",
                                              "name": txtName.text ?? "",
                                              "userName": userNme,
                                              "binID": txtBinID.text ?? "",
                                              "area": txtArea.text ?? "",
                                              "locality":txtLocality.text ?? "",
                                              "city":txtCity.text ?? "",
                                              "assignBin":txtAssignBin.text ?? "",
                                              "complaint":txtComplaint.text ?? "",
                                              "userId":idKyes,
                                              "complainStatus":ComplainStatus.Pening.rawValue]
         //"userType":self.userType.rawValue]
        chatRefrence.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Success", message: "Complaint added successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
                }
                } else {
                    print(error!)
                    return
                }
            }
        }
    
    func getbins() {
       self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.binList)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            self?.stopAnimating()
            if let value = snapshot.value as? [String:AnyObject] {
                print("value is \(value)")
                 value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self?.bins.append(BinModel(dic: dic, key: key))
                    }
                }
                self?.txtAssignBin.text = self?.bins.first?.binID ?? ""
                self?.selectedBin = self?.bins.first
                
            }
        }
    }
}

