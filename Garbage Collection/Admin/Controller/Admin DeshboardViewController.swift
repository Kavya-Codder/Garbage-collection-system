//
//  Admin DeshboardViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit

class Admin_DeshboardViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewFeedbackView: UIView!
    @IBOutlet weak var complainsListView: UIView!
    @IBOutlet weak var driverListView: UIView!
    @IBOutlet weak var createDriverView: UIView!
    @IBOutlet weak var binListView: UIView!
    @IBOutlet weak var createBinView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
        initialSetUp()
    }
    func nevConfigration() {
        self.title = "Garbage Collector"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .white
    
    }
    override func viewWillAppear(_ animated: Bool) {
        nevConfigration()
    }


    @IBAction func onClickPushToCreateBinScreen(_ sender: UIButton) {
        let createBinVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateBinViewController") as! CreateBinViewController
       
        navigationController?.pushViewController(createBinVC, animated: true)
    }
    
    @IBAction func onClickPushToBinListScreen(_ sender: UIButton) {
        let binListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "BinListTableViewController") as! BinListTableViewController
       
        navigationController?.pushViewController(binListVC, animated: true)
    }
 
    @IBAction func onClickPushToCreateDriverScreen(_ sender: UIButton) {
        let createDriverVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateDriverViewController") as! CreateDriverViewController
        
        navigationController?.pushViewController(createDriverVC, animated: true)
    }
    
    
    @IBAction func onClickPushToDriverListScreen(_ sender: UIButton) {
        let driverListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "DriverListViewController") as! DriverListViewController
       
        navigationController?.pushViewController(driverListVC, animated: true)
    }
   

    @IBAction func onClickPushToComplaintListScreen(_ sender: UIButton) {
        let complaintListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "ComplaintsListViewController") as! ComplaintsListViewController
        
    navigationController?.pushViewController(complaintListVC, animated: true)
    }
    
    @IBAction func onClickPushToViewFeedbackScreen(_ sender: UIButton) {
        let viewFeedbackVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
      
    navigationController?.pushViewController(viewFeedbackVC, animated: true)
    }
    

    func initialSetUp() {
        createBinView.layer.cornerRadius = 20
        binListView.layer.cornerRadius = 20
        createDriverView.layer.cornerRadius = 20
        driverListView.layer.cornerRadius = 20
        complainsListView.layer.cornerRadius = 20
       viewFeedbackView.layer.cornerRadius = 20
    }
}
