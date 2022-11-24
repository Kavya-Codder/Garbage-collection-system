//
//  UserProfileViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase
import FirebaseStorage

enum UserProfileValidation: String {
    case firstName = "Please enter First Name"
    case lastName = "Please enter Last Name"
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


class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var txtNo: UITextField!
    @IBOutlet weak var txtIDProof: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    
    var genders = ["Male","Female","Other"]
    var idProofs = ["Aadhar Card", "PAN", "Boter ID"]
    
    var genderPicker: UIPickerView!
    var idProofPicker: UIPickerView!
    var currentTextField = UITextField()
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode =  .date
        datePicker.maximumDate = Date()
        //ImagePicker
        imagePicker.delegate = self
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
        
        // Gender PickerView
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        txtGender.inputView = genderPicker
        txtGender.text = genders.first
        txtGender.delegate = self
        
        //IDProof PickerView
        idProofPicker = UIPickerView()
        idProofPicker.delegate = self
        idProofPicker.dataSource = self
        txtIDProof.inputView = idProofPicker
        txtIDProof.text = idProofs.first
        lblNo.text = "\(idProofs.first ?? "") Number"
        txtIDProof.delegate = self
        initialSetUpUserProfile()
        displayuserDetails()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    func initialSetUpUserProfile() {
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.height/2
        imgUserProfile.clipsToBounds = true
        genderPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        idProofPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        
        setStyle(textField: txtFirstName)
        setStyle(textField: txtLastName)
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
        
        txtFirstName.setLeftPaddingPoints(10)
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
        btnCamera.layer.cornerRadius = btnCamera.frame.height / 2
        btnCamera.clipsToBounds = true
        btnCamera.layer.borderWidth = 2
        btnCamera.layer.borderColor = UIColor(named: "appHeadingColour")? .cgColor
    }
    
    
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func onClickSubmitBtn(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
            uploaddriverImage()
        }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
     }
    
    
    func doValidation() -> (Bool,String)
    {
        if (txtFirstName.text?.isEmpty  ?? false)  {
            return (false,UserProfileValidation.firstName.rawValue)
        }else if (txtDOB.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.dob.rawValue)
        }
        else if (txtAge.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.age.rawValue)
        }
        else if (txtGender.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.gender.rawValue)
        }
        else if (txtMobile.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.mobile.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.city.rawValue)
        }
        else if (txtAddress.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.address.rawValue)
        }
        else if (txtEmail.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.email.rawValue)
        }
        else if (txtPassword.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.password.rawValue)
        }
        else if (txtIDProof.text?.isEmpty ?? false)  {
            return (false,UserProfileValidation.idProof.rawValue)
        }
        return (true,"")
    }
    
    func displayuserDetails()  {
        if let name = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String {
            txtFirstName.text = name
        }
        if let dobStr = UserDefaults.standard.value(forKey: UserKeys.dob.rawValue) as? String {
            txtDOB.text = dobStr
        }
        if let ageStr = UserDefaults.standard.value(forKey: UserKeys.age.rawValue) as? String {
            txtAge.text = ageStr
        }
        if let genderStr = UserDefaults.standard.value(forKey: UserKeys.gender.rawValue) as? String {
            txtGender.text = genderStr
        }
        if let mobileStr = UserDefaults.standard.value(forKey: UserKeys.mobile.rawValue) as? String {
            txtMobile.text = mobileStr
        }
        if let cityStr = UserDefaults.standard.value(forKey: UserKeys.city.rawValue) as? String {
            txtCity.text = cityStr
        }
        if let addressStr = UserDefaults.standard.value(forKey: UserKeys.address.rawValue) as? String {
            txtAddress.text = addressStr
        }
        if let emialsStr = UserDefaults.standard.value(forKey: UserKeys.emai.rawValue) as? String {
            txtEmail.text = emialsStr
        }
        if let passwordStr = UserDefaults.standard.value(forKey: UserKeys.password.rawValue) as? String {
            txtPassword.text = passwordStr
        }
        if let idProofStr = UserDefaults.standard.value(forKey: UserKeys.adharnumber.rawValue) as? String {
            txtIDProof.text = idProofStr
        }
        if let noStr = UserDefaults.standard.value(forKey: UserKeys.No.rawValue) as? String {
            txtNo.text = noStr
        }
        if let userProfile = UserDefaults.standard.value(forKey: UserKeys.userProfile.rawValue) as? String {
            self.getImageurl(imageName:userProfile) { imageUrl in
                self.imgUserProfile.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle.fill"))
            }
        }
    }
    
}

////MARK:- PickerView Delegate and DataSource
extension UserProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if currentTextField == txtGender{
            currentTextField.inputView = genderPicker
        }else if currentTextField == txtIDProof{
            currentTextField.inputView = idProofPicker
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtGender{
            return genders.count
        }else if currentTextField == txtIDProof{
            return idProofs.count
        }
        else {
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtGender{
            return genders[row]
        }else if currentTextField == txtIDProof{
            return idProofs[row]
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
            self.txtIDProof.text = idProofs[row]
            self.lblNo.text = "\(idProofs[row]) Number"
            self.view.endEditing(true)
        }
        
    }
    
    func updateProfile(imageName: String)  {
        self.startAnimating()
        let userid = UserDefaults.standard.value(forKey: UserKeys.key.rawValue) as? String
         let ref = Database.database().reference().root.child(FirebaseDB.usersList).child(userid ?? "")
        let paramValue:[AnyHashable : Any] = [
            "name":txtFirstName.text ?? "",
            "dob": txtDOB.text ?? "",
            "mobile": txtMobile.text ?? "",
            "city": txtCity.text ?? "",
            "address": txtAddress.text ?? "",
            "age": txtAge.text ?? "",
            "password": txtPassword.text ?? "",
            "userProfile": imageName
         ]
        ref.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Success", message: "Profile updated successfully", buttons: ["ok"]) { (str) in
                    UserDefaults.standard.set(self.txtAge.text ?? "", forKey:  UserKeys.age.rawValue)
                    UserDefaults.standard.set(self.txtCity.text ?? "", forKey: UserKeys.city.rawValue)
                    UserDefaults.standard.set(self.txtDOB.text ?? "", forKey:  UserKeys.dob.rawValue)
                    UserDefaults.standard.set(self.txtMobile.text ?? "", forKey:  UserKeys.mobile.rawValue)
                    UserDefaults.standard.set("\(self.txtFirstName.text ?? "") \(self.txtLastName.text ?? "")", forKey:  UserKeys.name.rawValue)
                    UserDefaults.standard.set(self.txtPassword.text ?? "", forKey:  UserKeys.password.rawValue)
                    UserDefaults.standard.set(imageName, forKey:  UserKeys.userProfile.rawValue)
                 }
            } else {
                print(error!)
                return
            }
        }
     }
    
    func uploaddriverImage()  {
        let storageRef = Storage.storage().reference()
        let imageName = UUID().uuidString
        let riversRef = storageRef.child("Driver/\(imageName).jpg")
        let imageData = self.imgUserProfile.image?.jpegData(compressionQuality: 0.1)
        self.startAnimating()
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData ?? Data(), metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            self.updateProfile(imageName: imageName)
         }
    }
    
    
    func getImageurl(imageName: String, completion: @escaping(URL)->Void)  {
        let gsReference = Storage.storage().reference(forURL:  "gs://garbage-collection-76329.appspot.com/Driver/\(imageName).jpg")
        print(gsReference.fullPath)//imageFolder/abc.jpg
        print(gsReference.bucket)//yourapp-206323.appspot.com
        print(gsReference.name)//abc.jpg
        gsReference.downloadURL(completion: { (url, error) in
            if let _url = url{
                print(_url.path,"url by me")
                completion(_url)
             }
        })
    }
    
}

//Mark:- Photo/Gallery delegate
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.imgUserProfile.image = selectedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    }
