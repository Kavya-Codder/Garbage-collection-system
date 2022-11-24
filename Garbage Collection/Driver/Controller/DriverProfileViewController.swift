//
//  DriverProfileViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import FirebaseStorage
import SDWebImage

class DriverProfileViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgDriverProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         setStyle(textField: txtName)
        setStyle(textField: txtAge)
        setStyle(textField: txtGender)
        setStyle(textField: txtMobileNo)
        setStyle(textField: txtAddress)
        setStyle(textField: txtPassword)
        setStyle(textField: txtEmail)
        
        txtName.setLeftPaddingPoints(10)
        txtAge.setLeftPaddingPoints(10)
        txtGender.setLeftPaddingPoints(10)
        txtMobileNo.setLeftPaddingPoints(10)
        txtAddress.setLeftPaddingPoints(10)
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        
        displayDriverDetails()
        imgDriverProfile.layer.cornerRadius = imgDriverProfile.frame.height/2
    }
    
    @IBAction func btNBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
 
    func displayDriverDetails()  {
        if let name = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String {
            txtName.text = name
        }
        
        if let ageStr = UserDefaults.standard.value(forKey: UserKeys.age.rawValue) as? String {
            txtAge.text = ageStr
        }
        if let genderStr = UserDefaults.standard.value(forKey: UserKeys.gender.rawValue) as? String {
            txtGender.text = genderStr
        }
        if let mobileStr = UserDefaults.standard.value(forKey: UserKeys.mobile.rawValue) as? String {
            txtMobileNo.text = mobileStr
        }
         
        if let addressStr = UserDefaults.standard.value(forKey: UserKeys.address.rawValue) as? String {
            txtAddress.text = addressStr
        }
        if let emailStr = UserDefaults.standard.value(forKey: UserKeys.emai.rawValue) as? String {
            txtEmail.text = emailStr
        }
        if let passwordStr = UserDefaults.standard.value(forKey: UserKeys.password.rawValue) as? String {
            txtPassword.text = passwordStr
        }
        if let userProfile = UserDefaults.standard.value(forKey: UserKeys.userProfile.rawValue) as? String {
            self.getImageurl(imageName:userProfile) { imageUrl in
                self.imgDriverProfile.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle.fill"))
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
