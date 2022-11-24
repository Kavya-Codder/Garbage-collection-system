//
//  RegisterViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 13/07/22.
//

import UIKit
import Firebase
import FirebaseDatabase

enum UserType: String {
case User = "1"
case Admin = "2"
case Driver = "3"
}

enum RegisterValidation: String {
    case name = "Please enter name"
    case dob = "Please enter DOB"
    case age = "Please enter age"
    case gender = "Please enter gender"
    case mobile = "Please enter mobile"
    case city = "Please enter city"
    case address = "Please enter address"
    case email = "Please enter email"
    case password = "Please enter password"
    case idProof = "Please enter idProof "
    case no = "Please enter no"
    case inCorrectLogin = "Please enter correct  email and password"
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtNo: UITextField!
    @IBOutlet weak var txtIDProof: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var lblNo: UILabel!
    
    
    @IBOutlet weak var image: UIImageView!
    
    var genders = ["Male","Female","Other"]
    var idProof = ["Aadhar Card", "PAN", "Boter ID"]
    
    var idProofPicker: UIPickerView!
    var gradePicker: UIPickerView!
    var currentTextField = UITextField()
    
    let datePicker = UIDatePicker()
    var userType: UserType = .User
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
   //DatePickerView
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

        datePicker.backgroundColor = .lightGray
        //  datePicker.setValue(UIColor.white, forKey: "textColor")

            datePicker.datePickerMode =  .date
//            datePicker.minimumDate = Date()
//        datePicker.maximumDate = Date()
            


        //ToolBar
        let toolbar = UIToolbar()
        toolbar.barTintColor = UIColor(named: "appBorderColour")
        toolbar.isTranslucent = true
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        doneButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = .white
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        txtDOB.inputAccessoryView = toolbar
        txtDOB.inputView = datePicker
       
        
        //Gender
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        txtGender.inputView = gradePicker
        txtGender.text = genders.first
        txtGender.delegate = self
        
        //IDProof
        idProofPicker = UIPickerView()
        idProofPicker.delegate = self
        idProofPicker.dataSource = self
        
        txtIDProof.inputView = idProofPicker
        txtIDProof.text = idProof.first
        lblNo.text = "\(idProof.first ?? "") Number"
        txtIDProof.delegate = self
        
        //ImagePicker
        imagePicker.delegate = self
        
       registerInitialSetUp()
        
        
    }
    
    //Mark:- Photo/Gallery imagePicker
    

    @IBAction func onClickImageAddBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Media Demo", message: "Please slect option Gallery or Camera", preferredStyle:.actionSheet)
        let galery = UIAlertAction(title: "Gallery", style: .default) { alert in
            self.openGallery()
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { alert in
            self.openCamera()
        }
        alert.addAction(galery)
        alert.addAction(camera)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onClickSubmitBtn(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
            if !(txtName.text?.isEmpty ?? true ) && !(txtDOB.text?.isEmpty ?? true ) && !(txtAge.text?.isEmpty ?? true ) && !(txtGender.text?.isEmpty ?? true ) && !(txtMobile.text?.isEmpty ?? true ) && !(txtCity.text?.isEmpty ?? true ) && !(txtAddress.text?.isEmpty ?? true ) && !(txtEmail.text?.isEmpty ?? true ) && !(txtPassword.text?.isEmpty ?? true ) && !(txtIDProof.text?.isEmpty ?? true ) && !(txtNo.text?.isEmpty ?? true ) {
                 uploadBinImage()
            }
        }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }

}
    
    @objc func doneDatePicker() {
    let formatter = DateFormatter()
         formatter.dateFormat = "dd-MM-yyyy"
    txtDOB.text = formatter.string(from: datePicker.date)
    //            formatter.dateFormat = "hh:mm a"
    //            txtfChooseTime.text = formatter.string(from: timePicker.date)

    self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
    self.view.endEditing(true)
    }
    
    
    @IBAction func onClickHaveanAccountBtn(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    
    func registerInitialSetUp() {
        btnCamera.layer.cornerRadius = btnCamera.frame.height / 2
        btnCamera.clipsToBounds = true
        btnCamera.layer.borderWidth = 2
        btnCamera.layer.borderColor = UIColor(named: "appHeadingColour")? .cgColor
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = true
        
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        
        gradePicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        idProofPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        //gradePicker.increaseSize(100)
        txtName.setLeftPaddingPoints(10)
        txtDOB.setLeftPaddingPoints(10)
        txtAge.setLeftPaddingPoints(10)
        txtGender.setLeftPaddingPoints(10)
        txtMobile.setLeftPaddingPoints(10)
        txtCity.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        txtIDProof.setLeftPaddingPoints(10)
        txtNo.setLeftPaddingPoints(10)
        
        setStyle(textField: txtName)
        setStyle(textField: txtDOB)
        setStyle(textField: txtAge)
        setStyle(textField: txtGender)
        setStyle(textField: txtMobile)
        setStyle(textField: txtCity)
        setStyle(textField: txtAddress)
        setStyle(textField: txtEmail)
        setStyle(textField: txtPassword)
        setStyle(textField: txtIDProof)
        setStyle(textField: txtNo)
        
    }
    func setStyle(textField : UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        textField.layer.borderWidth = 1
    }
        
    func doValidation() -> (Bool,String)
       {
        if (txtName.text?.isEmpty  ?? false)  {
            return (false,RegisterValidation.name.rawValue)
        }else if (txtDOB.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.dob.rawValue)
        }else if (txtAge.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.age.rawValue)
        }
        else if (txtGender.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.gender.rawValue)
        }
        else if (txtMobile.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.mobile.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.city.rawValue)
        }
        else if (txtAddress.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.address.rawValue)
        }
        else if (txtEmail.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.email.rawValue)
        }
        else if (txtPassword.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.password.rawValue)
        }
        else if (txtIDProof.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.idProof.rawValue)
        }
        else if (txtNo.text?.isEmpty ?? false)  {
            return (false,RegisterValidation.no.rawValue)
        }
        return (true,"")
    }


}




//MARK:- PickerView Delegate and DataSource
extension RegisterViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if textField == txtGender {
            textField.inputView = gradePicker
        }else if textField == txtIDProof {
            textField.inputView = idProofPicker
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtGender{
            return genders.count
        }else if currentTextField == txtIDProof{
            return idProof.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtGender{
            return genders[row]
        }else if currentTextField == txtIDProof{
            return idProof[row]
        }
        else {
            return ""
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == txtGender{
            self.txtGender.text = genders[row]
            self.view.endEditing(true)
        }else if currentTextField == txtIDProof{
            self.txtIDProof.text = idProof[row]
            self.lblNo.text = "\(idProof[row]) Number"
            self.view.endEditing(true)
        }
        
    }
}


//Firebase Utilities from here
extension RegisterViewController {
    func registerUser(imageName: String) {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        let chatRefrence = ref.childByAutoId()
        let paramValue:[AnyHashable : Any] = ["id":"\(UUID().uuidString)",
                                              "name": txtName.text ?? "",
                                              "dob":txtDOB.text ?? "",
                                              "mobile":txtMobile.text ?? "",
                                              "city":txtCity.text ?? "",
                                              "gender":txtGender.text ?? "",
                                              "address":txtAddress.text ?? "",
                                              "age":txtAge.text ?? "",
                                              "emai":txtEmail.text ?? "",
                                              "adharnumber":txtNo.text ?? "",
                                              "password":txtPassword.text ?? "",
                                              "userType":self.userType.rawValue,
                                              "OTP":"",
                                              "no":self.txtNo.text ?? "",
                                              "userProfile": imageName]
        chatRefrence.updateChildValues(paramValue) { (error, ref) in
            if error == nil {
                self.stopAnimating()
                self.displayAlert(with: "Success", message: "You have been registered successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                
            } else {
                print(error!)
                return
            }
        }
    }
    
    func uploadBinImage()  {
        let storageRef = Storage.storage().reference()
        let imageName = UUID().uuidString
        let riversRef = storageRef.child("Driver/\(imageName).jpg")
        let imageData = self.image.image?.jpegData(compressionQuality: 0.1)
        self.startAnimating()
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData ?? Data(), metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            self.registerUser(imageName: imageName)
         }
    }
    
}

//Mark:- Photo/Gallery delegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera source type is not available")
        }
    }
    
    
    func openGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.image.image = selectedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    }


