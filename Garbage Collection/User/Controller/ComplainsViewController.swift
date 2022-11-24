//
//  ComplainsViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit

class ComplainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
        
        setStyle(textField: searchTxt)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickPlushButton(_ sender: Any) {
        let addComplainsVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "AddComplaintViewController") as! AddComplaintViewController
        navigationController?.pushViewController(addComplainsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplainsTableViewCell", for: indexPath) as! ComplainsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    func setStyle(textField : UITextField) {
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(named: "appBorderColour")? .cgColor
        textField.layer.borderWidth = 1
    }
    

}
