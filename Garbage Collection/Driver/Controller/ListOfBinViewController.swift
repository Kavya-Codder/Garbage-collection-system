//
//  ListOfBinViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit
import Firebase
class ListOfBinViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var bins:[BinModel] = []
    override func viewDidLoad() {
     getbins()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 15, left:0 , bottom: 0, right: 0)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfBinTableViewCell", for: indexPath) as! ListOfBinTableViewCell
        let obj = bins[indexPath.row]
        cell.lblBinID.text = "Bin Name: \(obj.binID ?? "")"
        cell.lblArea.text = "Area: \(obj.area ?? "")"
        cell.lblCity.text = "City: \(obj.city ?? "")"
        cell.lblDriverName.text = "Driver Name: \(obj.assignDriver ?? "")"
        cell.lblBinType.text = "Complaint: \(obj.garbageType ?? "")"
        cell.lblCyclePeriod.text = "Complaint: \(obj.cyclePeriod ?? "")"
        self.getImageurl(imageName: obj.binImage ?? "") { imageUrl in
            cell.imgBin.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "binImage"))
        }
        cell.selectionStyle = .none
        return cell
        
    }
    func getbins() {
        self.startAnimating()
        let userId = UserDefaults.standard.value(forKey: UserKeys.id.rawValue) as! String
        let ref = Database.database().reference().child(FirebaseDB.binList)
        ref.queryOrdered(byChild: "driverID").queryEqual(toValue: userId).observeSingleEvent(of: .value) { (dataSnapShot) in
            self.stopAnimating()
            if let value = dataSnapShot.value as? [String:AnyObject] {
                print("value is \(value)")
                value.forEach { (key,Value) in
                    if let dic = Value as? [String:AnyObject] {
                        self.bins.append(BinModel(dic: dic, key: key))
                    }
                }
                 self.tableView.reloadData()
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

