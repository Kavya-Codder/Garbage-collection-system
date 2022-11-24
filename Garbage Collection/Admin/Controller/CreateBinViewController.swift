//
//  CreateBinViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 17/07/22.
//

import UIKit
import Firebase
import FirebaseDatabase

enum CreateBinScreenValidation: String {
    case binID = "Please enter Bin ID"
    case area = "Please enter Area"
    case locality = "Please enter Locality"
    case city = "Please enter City"
    case garbageType = "Please enter Garbage Type"
    case assignDriver = "Please enter Assign Driver"
    case cyclePeriod = "Please enter Cycle Period"
}

class CreateBinViewController: UIViewController {
    
    @IBOutlet weak var txtAssignDriver: UITextField!
    @IBOutlet weak var btnCamara: UIButton!
    @IBOutlet weak var txtCyclePeriod: UITextField!
    @IBOutlet weak var txtGarbageType: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtLocality: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtBinID: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    let cyclePeriod = ["Daily", "Weekly"]
    let garbageType = ["Liquid Waste", "Solid Waste"]
    let assignDriver = ["Ramesh Soni", "Vikas Sahu"]
    var drivers:[UserModel] = []
    var selectedDriver: UserModel?
    
    var cyclePeriodPicker: UIPickerView!
    var garbageTypePicker: UIPickerView!
    var assignDriverPicker: UIPickerView!
    var currentTextField = UITextField()
    var binObj:BinModel?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDriver()
        //CyclePeriod PickerView
        cyclePeriodPicker = UIPickerView()
        cyclePeriodPicker.delegate = self
        cyclePeriodPicker.dataSource = self
        
        txtCyclePeriod.inputView = cyclePeriodPicker
        txtCyclePeriod.text = cyclePeriod.first
        txtCyclePeriod.delegate = self
        
        //GarbageType PickerView
        garbageTypePicker = UIPickerView()
        garbageTypePicker.delegate = self
        garbageTypePicker.dataSource = self
        
        txtGarbageType.inputView = garbageTypePicker
        txtGarbageType.text = garbageType.first
        txtGarbageType.delegate = self
        
        //assignDriver PickerView
        assignDriverPicker = UIPickerView()
        assignDriverPicker.delegate = self
        assignDriverPicker.dataSource = self
        
        txtAssignDriver.inputView = assignDriverPicker
       
        txtAssignDriver.delegate = self
        
        //ImagePicker
        imagePicker.delegate = self
        
        initialSetUpCreateBinVC()
        dispalyBinDetails()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    @IBAction func onClickSubmitBtn(_ sender: UIButton) {
        let validation = doValidation()
        if validation.0 {
            uploadBinImage()
         }else {
            self.ShowAlert(title:"", message: validation.1, handler: nil)
        }
        
    }
    func initialSetUpCreateBinVC()
    {
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = true
        btnCamara.layer.cornerRadius = btnCamara.frame.height / 2
        btnCamara.clipsToBounds = true
        btnCamara.layer.borderWidth = 2
        btnCamara.layer.borderColor = UIColor(named: "appHeadingColour")? .cgColor
        buttonSubmit.layer.cornerRadius = 20
        buttonSubmit.clipsToBounds = true
        setStyle(textField: txtBinID)
        setStyle(textField: txtArea)
        setStyle(textField: txtLocality)
        setStyle(textField: txtCity)
        setStyle(textField: txtGarbageType)
        setStyle(textField: txtAssignDriver)
        setStyle(textField: txtCyclePeriod)
        
        txtBinID.setLeftPaddingPoints(10)
        txtArea.setLeftPaddingPoints(10)
        txtLocality.setLeftPaddingPoints(10)
        txtCity.setLeftPaddingPoints(10)
        txtGarbageType.setLeftPaddingPoints(10)
        txtAssignDriver.setLeftPaddingPoints(10)
        txtCyclePeriod.setLeftPaddingPoints(10)
        
        garbageTypePicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        assignDriverPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
        cyclePeriodPicker.layer.backgroundColor = UIColor(named: "appBorderColour")? .cgColor
    }
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    func doValidation() -> (Bool,String)//0 = true/false, 1 = message
    {
        if (txtBinID.text?.isEmpty  ?? false)  {
            return (false,CreateBinScreenValidation.binID.rawValue)
        }else if (txtArea.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.area.rawValue)
        }
        else if (txtLocality.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.locality.rawValue)
        }
        else if (txtCity.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.city.rawValue)
        }
        else if (txtGarbageType.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.garbageType.rawValue)
        }
        else if (txtAssignDriver.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.assignDriver.rawValue)
        }
        else if (txtCyclePeriod.text?.isEmpty ?? false)  {
            return (false,CreateBinScreenValidation.cyclePeriod.rawValue)
        }
        return (true,"")
    }
}
extension CreateBinViewController: UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if textField == txtGarbageType {
            textField.inputView = garbageTypePicker
        }else if textField == txtAssignDriver {
            textField.inputView = assignDriverPicker
        }else if textField == txtCyclePeriod {
            textField.inputView = cyclePeriodPicker
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtGarbageType{
            return garbageType.count
        }else if currentTextField == txtAssignDriver{
            return drivers.count
        }else if currentTextField == txtCyclePeriod{
            return cyclePeriod.count
        }
        else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtGarbageType{
            return garbageType[row]
        }else if currentTextField == txtAssignDriver{
            return drivers[row].name ?? ""
        }else if currentTextField == txtCyclePeriod{
            return cyclePeriod[row]
        }
        else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == txtGarbageType{
            self.txtGarbageType.text = garbageType[row]
            self.view.endEditing(true)
        }else if currentTextField == txtAssignDriver {
            self.txtAssignDriver.text = drivers[row].name ?? ""
            self.selectedDriver = drivers[row]
            self.view.endEditing(true)
        }else if currentTextField == txtCyclePeriod {
            self.txtCyclePeriod.text = cyclePeriod[row]
            self.view.endEditing(true)
        }
        
    }
    
    
    func dispalyBinDetails()  {
        if let bin = self.binObj {
            txtBinID.text = bin.binID ?? ""
            txtArea.text = bin.area ?? ""
            txtLocality.text = bin.locality ?? ""
            txtCity.text = bin.city ?? ""
            txtGarbageType.text = bin.garbageType ?? ""
            txtAssignDriver.text = bin.assignDriver ?? ""
            txtCyclePeriod.text = bin.cyclePeriod ?? ""
            self.getImageurl(imageName: bin.binImage ?? "") { imageUrl in
                self.image.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle.fill"))
            }
            self.selectedDriver = self.drivers.filter({ user in
                return user.id == bin.driverID
            }).first
        }
    }
    
}

//Firebase Utilities from here
extension CreateBinViewController {
    
    func createBin(binImageName: String) {
        self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.binList)
        let chatRefrence = ref.childByAutoId()
        let paramValue:[AnyHashable : Any] = ["id":"\(UUID().uuidString)",
                                              "binID": txtBinID.text ?? "",
                                              "area": txtArea.text ?? "",
                                              "locality":txtLocality.text ?? "",
                                              "city":txtCity.text ?? "",
                                              "garbageTyper":txtGarbageType.text ?? "",
                                              "DriverName":txtAssignDriver.text ?? "",
                                              "cyclePeriod":txtCyclePeriod.text ?? "",
                                              "driverID":selectedDriver?.id ?? "",
                                              "binImage": binImageName
        ]
        chatRefrence.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Success", message: "Bin Added successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print(error!)
                return
            }
        }
    }
    
    
    func getDriver() {
       self.startAnimating()
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        ref.queryOrdered(byChild: "userType").queryEqual(toValue: "3").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            self?.stopAnimating()
            if let value = snapshot.value as? [String:AnyObject] {
                print("value is \(value)")
                 value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self?.drivers.append(UserModel(dic: dic, key: key))
                    }
                }
                self?.txtAssignDriver.text = self?.drivers.first?.name ?? ""
                self?.selectedDriver = self?.drivers.first
                
            }
        }
    }

    func updateBin(binObj: BinModel?, binImageName: String)  {
        self.startAnimating()
         let ref = Database.database().reference().root.child(FirebaseDB.binList).child(binObj?.key ?? "")
        let paramValue:[AnyHashable : Any] = [
                                              "binID": txtBinID.text ?? "",
                                              "area": txtArea.text ?? "",
                                              "locality":txtLocality.text ?? "",
                                              "city":txtCity.text ?? "",
                                              "garbageTyper":txtGarbageType.text ?? "",
                                              "DriverName":txtAssignDriver.text ?? "",
                                              "cyclePeriod":txtCyclePeriod.text ?? "",
                                              "driverID":selectedDriver?.id ?? "",
                                              "binImage": binImageName]
        ref.updateChildValues(paramValue) { (error, ref) in
            self.stopAnimating()
            if error == nil {
                self.displayAlert(with: "Success", message: "Bin updated successfully", buttons: ["ok"]) { (str) in
                    self.navigationController?.popViewController(animated: true)
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
            if let objBin = self.binObj {
                self.updateBin(binObj: objBin, binImageName: imageName)
            } else {
                self.createBin(binImageName: imageName)
            }
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
extension CreateBinViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

