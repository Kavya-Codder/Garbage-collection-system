//
//  CreateDriverViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 17/07/22.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

enum CreateDriverValidation: String {
    case firstName = "Please enter Fiest Name"
    case lastName = "Please enter Last Name"
    case dob = "Please select DOB"
    case age = "Please enter age"
    case gender = "Please select Gender"
    case mobile = "Please enter Mobile No"
    case address = "Please enter Address"
    case city = "Please enter city"
    case email = "Please enter Email"
    case password = "Please enter password"
    case idProof = "Please enter idProof "
    case no = "Please enter no "
    case assignBin = "Please enter Assign Bin"
    case inCorrectLogin = "Please enter correct  email and password"
}

class CreateDriverViewController: UIViewController {

    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtAssignBin: UITextField!
    @IBOutlet weak var txtno: UITextField!
    @IBOutlet weak var txtIDProof: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var image: UIImageView!
    var genders = ["Male","Female","Other"]
    var idProofs = ["Aadhar Card", "PAN", "Boter ID"]
    var assignBin = ["bin101","bin102"]
    
    var genderPicker: UIPickerView!
    var idProofPicker: UIPickerView!
    var assignBinPicker: UIPickerView!
    var currentTextField = UITextField()
    var bins:[BinModel] = []
    
    let datePicker = UIDatePicker()
    var driver: UserModel?
    var selectedBin: BinModel?
    
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
        //  datePicker.setValue(UIColor.white, forKey: "textColor")

            datePicker.datePickerMode =  .date
//            datePicker.minimumDate = Date()
        datePicker.maximumDate = Date()
            


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
        
        //assignBin PickerView
        assignBinPicker = UIPickerView()
        assignBinPicker.delegate = self
        assignBinPicker.dataSource = self
        
        txtAssignBin.inputView = assignBinPicker
        txtAssignBin.text = assignBin.first
        txtAssignBin.delegate = self
        
        //ImagePicker
        imagePicker.delegate = self
        
        initialSetUpCreateDriver()
        getBins()
        driverDetailsObj()
        
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
    
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let validation = doValidation()
        if validation.0 {
            self.uploaddriverImage()
        }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
}
    
    func initialSetUpCreateDriver(){
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = true
        btnCamera.layer.cornerRadius = btnCamera.frame.height / 2
        btnCamera.clipsToBounds = true
        buttonAdd.layer.cornerRadius = 20
        buttonAdd.clipsToBounds = true
        btnCamera.layer.borderWidth = 2
        btnCamera.layer.borderColor = UIColor(named: "appHeadingColour")? .cgColor
        genderPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        idProofPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        assignBinPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        
        txtFirstName.setLeftPaddingPoints(10)
        txtLastName.setLeftPaddingPoints(10)
        txtDOB.setLeftPaddingPoints(10)
        txtAge.setLeftPaddingPoints(10)
        txtGender.setLeftPaddingPoints(10)
        txtMobileNo.setLeftPaddingPoints(10)
        txtCity.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        txtIDProof.setLeftPaddingPoints(10)
        txtno.setLeftPaddingPoints(10)
        txtAssignBin.setLeftPaddingPoints(10)
        
        setStyle(textField: txtFirstName)
        setStyle(textField: txtLastName)
        setStyle(textField: txtDOB)
        setStyle(textField: txtAge)
        setStyle(textField: txtGender)
        setStyle(textField: txtMobileNo)
        setStyle(textField: txtAddress)
        setStyle(textField: txtCity)
        setStyle(textField: txtEmail)
        setStyle(textField: txtPassword)
        setStyle(textField: txtIDProof)
        setStyle(textField: txtno)
        setStyle(textField: txtAssignBin)
        
    }
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    func doValidation() -> (Bool,String)//0 = true/false, 1 = message
       {
        if (txtFirstName.text?.isEmpty  ?? false)  {
            return (false,CreateDriverValidation.firstName.rawValue)
        }else if (txtLastName.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.lastName.rawValue)
        }else if (txtDOB.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.dob.rawValue)
        }
        else if (txtAge.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.age.rawValue)
        }else if (txtGender.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.gender.rawValue)
        }
        else if (txtMobileNo.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.mobile.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.city.rawValue)
        }
        else if (txtAddress.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.address.rawValue)
        }
        else if (txtEmail.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.email.rawValue)
        }
        else if (txtPassword.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.password.rawValue)
        }
        else if (txtIDProof.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.idProof.rawValue)
        }
        else if (txtno.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.no.rawValue)
        }
        else if (txtAssignBin.text?.isEmpty ?? false)  {
            return (false,CreateDriverValidation.assignBin.rawValue)
        }
        return (true,"")
    }
    
    func driverDetailsObj()  {
        if let objDriver = self.driver {
            txtFirstName.text = "\(String(describing: objDriver.name?.split(separator:" ").first ?? "") )"
            txtLastName.text = "\(String(describing: objDriver.name?.split(separator:" ").last ?? "") )"
            txtDOB.text = objDriver.dob ?? ""
            txtMobileNo.text = objDriver.mobile ?? ""
            txtCity.text = objDriver.city ?? ""
            txtGender.text = objDriver.gender ?? ""
            txtAddress.text = objDriver.address ?? ""
            txtAge.text = objDriver.age ?? ""
            txtEmail.text = objDriver.emai ?? ""
            txtIDProof.text = objDriver.adharnumber ?? ""
            txtno.text = objDriver.No ?? ""
            lblNo.text = "\(objDriver.adharnumber ?? "") Number"
            txtPassword.text = objDriver.password ?? ""
            txtAssignBin.text = objDriver.binName ?? ""
            self.getImageurl(imageName: objDriver.userProfile ?? "") { imageUrl in
                self.image.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle.fill"))
            }
            self.selectedBin = self.bins.filter({ bin in
                return bin.id == self.selectedBin?.binID
            }).first
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
    
////MARK:- PickerView Delegate and DataSource
extension CreateDriverViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if currentTextField == txtGender{
            currentTextField.inputView = genderPicker
        }else if currentTextField == txtIDProof{
            currentTextField.inputView = idProofPicker
        }else if currentTextField == txtAssignBin{
            currentTextField.inputView = assignBinPicker
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
        }else if currentTextField == txtAssignBin{
            return bins.count
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
        }else if currentTextField == txtAssignBin{
            return bins[row].binID
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
        }else if currentTextField == txtAssignBin{
            self.txtAssignBin.text = bins[row].binID
            self.selectedBin = bins[row]
            self.view.endEditing(true)
        }
        
    }
}

//Firebase Utilities from here
extension CreateDriverViewController {
    func createDriver(imageName: String) {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        let chatRefrence = ref.childByAutoId()
        let paramValue:[AnyHashable : Any] = ["id":"\(UUID().uuidString)",
                                              "name":  "\(txtFirstName.text ?? "") \(txtLastName.text ?? "")",
                                              "dob": txtDOB.text ?? "",
                                              "mobile": txtMobileNo.text ?? "",
                                              "city": txtCity.text ?? "",
                                              "gender": txtGender.text ?? "",
                                              "address": txtAddress.text ?? "",
                                              "age": txtAge.text ?? "",
                                              "emai": txtEmail.text ?? "",
                                              "adharnumber": txtIDProof.text ?? "",
                                              "no": txtno.text ?? "",
                                              "password": txtPassword.text ?? "",
                                              "userType": UserType.Driver.rawValue,
                                              "binId": self.selectedBin?.binID,
                                              "OTP": "",
                                              "BinName": txtAssignBin.text ?? "",
                                              "userProfile": imageName]
        chatRefrence.updateChildValues(paramValue) { (error, ref) in
            if error == nil {
                self.stopAnimating()
                self.displayAlert(with: "Success", message: "Driver has been added successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
                }
               
                 
            } else {
                print(error!)
                return
            }
        }
    }
    
    func getBins() {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.binList)
        ref.observeSingleEvent(of: .value) { (dataSnapShot) in
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.bins.append(BinModel(dic: dic, key:key))
                    }
                }
                self.txtAssignBin.text = self.bins.first?.binID ?? ""
                self.selectedBin = self.bins.first
                self.stopAnimating()
                 
                }
            }
            
        }
    
    func updateDriver(imageName : String) {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList).child(self.driver?.key ?? "")
        let paramValue:[AnyHashable : Any] = [
                                              "name":  "\(txtFirstName.text ?? "") \(txtLastName.text ?? "")",
                                              "dob": txtDOB.text ?? "",
                                              "mobile": txtMobileNo.text ?? "",
                                              "city": txtCity.text ?? "",
                                              "gender": txtGender.text ?? "",
                                              "address": txtAddress.text ?? "",
                                              "age": txtAge.text ?? "",
                                              "emai": txtEmail.text ?? "",
                                              "adharnumber": txtIDProof.text ?? "",
                                              "no": txtno.text ?? "",
                                              "OTP":"",
                                              "password": txtPassword.text ?? "",
                                              "userType":UserType.Driver.rawValue,
                                              "binId":self.selectedBin?.binID ?? "",
                                              "BinName":txtAssignBin.text ?? "",
                                              "userProfile":imageName]
        ref.updateChildValues(paramValue) { (error, ref) in
            if error == nil {
                self.stopAnimating()
                self.displayAlert(with: "Success", message: "Driver has been updated successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
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
        let imageData = self.image.image?.jpegData(compressionQuality: 0.1)
        self.startAnimating()
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData ?? Data(), metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            if self.driver != nil {
                self.updateDriver(imageName: imageName)
            } else {
                self.createDriver(imageName: imageName)
            }
         }
    }
}
//Mark:- Photo/Gallery delegate
extension CreateDriverViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
