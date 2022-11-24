//
//  HomeViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 23/07/22.
//

import UIKit

class HomeViewController: UIViewController {
   
    
    var homeItems = ["Home", "About","Logout"]
   
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // homeTableView.delegate = self
        homeTableView.dataSource = self
        
        homeTableView.separatorStyle = .none
        homeTableView.showsVerticalScrollIndicator = false

    }

    
}
extension HomeViewController: UITableViewDataSource {
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeItems.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
            
            let  home = homeItems[indexPath.row]
            
            cell.homeLbl.text = home
            cell.homeImgView.image = UIImage(named: home)
            
           // cell.homeView
            return cell
        }
}
