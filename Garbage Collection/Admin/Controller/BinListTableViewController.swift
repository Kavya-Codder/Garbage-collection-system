//
//  BinListTableViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit
import Firebase

struct BinModel {
    var binID: String?
    var id: String?
    var area: String?
    var locality: String?
    var city: String?
    var garbageType: String?
    var assignDriver: String?
    var cyclePeriod: String?
    var driverID: String?
    var binImage: String?
    var key:String = ""
    enum keyValue: String {
        case binID
        case area
        case locality
        case city
        case garbageType = "garbageTyper"
        case assignDriver = "DriverName"
        case cyclePeriod
        case driverID
        case id
        case binImage
    }
    init(dic: [String:AnyObject],key: String) {
        binID = dic[keyValue.binID.rawValue] as? String
        area = dic[keyValue.area.rawValue] as? String
        locality = dic[keyValue.locality.rawValue] as? String
        city = dic[keyValue.city.rawValue] as? String
        garbageType = dic[keyValue.garbageType.rawValue] as? String
        assignDriver = dic[keyValue.assignDriver.rawValue] as? String
        cyclePeriod = dic[keyValue.cyclePeriod.rawValue] as? String
        driverID = dic[keyValue.driverID.rawValue] as? String
        id = dic[keyValue.id.rawValue] as? String
        binImage = dic[keyValue.binImage.rawValue] as? String
        self.key = key
    }
}
 

class BinListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeleteDelegate {
   
    @IBOutlet weak var txtSearchBin: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var bins:[BinModel] = []
    var binsBackUp:[BinModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        setStyle(textField: txtSearchBin)
        txtSearchBin.setLeftPaddingPoints(10)
        txtSearchBin.addTarget(self, action: #selector(textSearchChange(_:)), for: .editingChanged)
    }
    
    @objc func textSearchChange(_ sender: UITextField){
        print(sender.text ?? "")
        if (sender.text?.isEmpty ?? false){
            self.bins = binsBackUp
        } else {
            bins = binsBackUp.filter({ bin in
                return (bin.binID ?? "").lowercased().contains((sender.text ?? "").lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBins()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDeleteBtn(_ sender: Any) {
       
                    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let binCell = tableView.dequeueReusableCell(withIdentifier: "BinListTableViewCell", for: indexPath) as! BinListTableViewCell
        let obj = bins[indexPath.row]
        binCell.lblBinID.text = "Bin Name: \(obj.binID ?? "")"
        binCell.lblArea.text = "Area: \(obj.area ?? "")"
        binCell.lblCity.text = "City: \(obj.city ?? "")"
        binCell.lblAssignDriver.text = "Driver Name: \(obj.assignDriver ?? "")"
        binCell.lblCyclePeriod.text = "Cycle Period: \(obj.cyclePeriod ?? "")"
        
        binCell.editBin = {
            let updateBinVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateBinViewController") as! CreateBinViewController
            updateBinVC.binObj = self.bins[indexPath.row]
            self.navigationController?.pushViewController(updateBinVC, animated: false)
        }
        binCell.deletebin = {
            let deleteVC = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "DeleteBinViewController") as!
                DeleteBinViewController
            deleteVC.deleate = self
            deleteVC.index = indexPath.row
            deleteVC.modalPresentationStyle = .overCurrentContext
            self.present(deleteVC, animated: true, completion: nil)
        }
        binCell.selectionStyle = .none
          return binCell
    }
    func setStyle(textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
    }
    
    func getBins() {
        self.startAnimating()
        self.bins.removeAll()
        let ref = Database.database().reference().child(FirebaseDB.binList)
        ref.observeSingleEvent(of: .value) { (dataSnapShot) in
            self.stopAnimating()
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.bins.append(BinModel(dic: dic, key:key))
                    }
                }
                self.binsBackUp = self.bins
                 self.tableView.reloadData()
                }
            }
            
        }

    func deleteBin(index:Int) {
        self.startAnimating()
        let ref = Database.database().reference().root.child(FirebaseDB.binList).child(bins[index].key )
        ref.removeValue()
        self.bins.removeAll()
        self.getBins()
    }
    
    


}
