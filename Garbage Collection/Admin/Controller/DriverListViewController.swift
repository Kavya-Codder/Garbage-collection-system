//
//  DriverListViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit
import Firebase
import SDWebImage

class DriverListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeleteDriverDelegate {
   
    

    @IBOutlet weak var txtSearchDriver: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var drivers:[UserModel] = []
    var driversBackeUP:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        txtSearchDriver.addTarget(self, action: #selector(textSearchChange(_:)), for: .editingChanged)
        setStyle(textField: txtSearchDriver)
    }
    override func viewWillAppear(_ animated: Bool) {
        getDriver()
    }
    
    @objc func textSearchChange(_ sender: UITextField){
        print(sender.text ?? "")
        if (sender.text?.isEmpty ?? false){
            self.drivers = driversBackeUP
        } else {
            drivers = driversBackeUP.filter({ driver in
                return (driver.name ?? "").lowercased().contains((sender.text ?? "").lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDeleteBtn(_ sender: Any) {
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "DriverListTableViewCell", for: indexPath) as! DriverListTableViewCell
        let obj = drivers[indexPath.row]
        cell.lblAdharNo.text = "Identity Card: \(obj.adharnumber ?? "")"
        cell.lblName.text = "Name: \(obj.name ?? "")"
        cell.lblMobile.text = "Mobile Number: \(obj.mobile ?? "")"
        cell.lblAddress.text = "Address: \(obj.address ?? "")"
        cell.lblAssignBin.text = "Bin Name: \(obj.binId ?? "")"
       // self.getImageurl(imageName: obj.userProfile ?? "", completion: (String) -> Void)
        self.getImageurl(imageName: obj.userProfile ?? "") { imageUrl in
            print(imageUrl,"at cell")
            cell.imgDriver.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle.fill"))
        }
        cell.editDriver = {
            let createDriverVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateDriverViewController") as! CreateDriverViewController
            createDriverVC.driver = self.drivers[indexPath.row]
            self.navigationController?.pushViewController(createDriverVC, animated: true)
        }
        cell.deleteDriver = {
            let deleteVC = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "DeleteDriverViewController") as!
                DeleteDriverViewController
            deleteVC.index = indexPath.row
            deleteVC.delegate = self
            deleteVC.modalPresentationStyle = .overCurrentContext
            self.present(deleteVC, animated: true, completion: nil)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        txtSearchDriver.setLeftPaddingPoints(10)
    }
    
    func getDriver() {
        self.startAnimating()
        self.drivers.removeAll()
        let ref = Database.database().reference().child(FirebaseDB.usersList)
        ref.queryOrdered(byChild: "userType").queryEqual(toValue: "3").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if let value = snapshot.value as? [String:AnyObject] {
                print("value is \(value)")
                self?.stopAnimating()
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self?.drivers.append(UserModel(dic: dic, key: key))
                    }
                }
                self?.driversBackeUP = self?.drivers ?? []

                self?.tableView.reloadData()
            }
        }
    }
    
    func deleteDriver(index: Int) {
        self.startAnimating()
        let ref = Database.database().reference().root.child(FirebaseDB.usersList).child(drivers[index].key )
        ref.removeValue()
        self.drivers.removeAll()
        self.getDriver()
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
    

