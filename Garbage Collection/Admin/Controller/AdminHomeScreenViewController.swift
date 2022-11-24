//
//  AdminHomeScreenViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 06/08/22.
//

import UIKit

struct AdminDeshboardModel {
    let title: String
    let image: UIImage
}

class AdminHomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var blurView = UIView()
    var leftView = UIView()
    var leftBlurView = UIView()
    var controller = LeftMenuViewController()
    
    var data:[AdminDeshboardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storedData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: AdminHomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AdminHomeCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth = (UIScreen.main.bounds.width - 110)/2
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: cellWidth, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 30, left: 45, bottom:10, right:45)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        scrollView.layer.cornerRadius = 35
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        navigationController?.navigationBar.isHidden = true
        addChildeVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navConfige()
    }
    
    func navConfige()  {
        self.title = "Garbage Collector"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "appPrimaryColour") ?? .white]
            navigationController?.navigationBar.tintColor = .black
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: AdminHomeCollectionViewCell.identifier, for: indexPath) as! AdminHomeCollectionViewCell
        let obj = data[indexPath.row]
        cell.lblText.text = obj.title
        cell.image.image = obj.image
        cell.layer.cornerRadius = 25
        cell.layer.shadowColor = UIColor.red.cgColor
        cell .layer.shadowOffset = CGSize(width: 2, height: 1)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.redirectToOther(indexPath: indexPath)
    }
    

    func redirectToOther(indexPath: IndexPath)   {
            switch indexPath.row {
            case 0:
    //            create bin
                let createBinVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateBinViewController") as! CreateBinViewController
                 navigationController?.pushViewController(createBinVC, animated: false)
                
                break
            case 1 :
                //bin list
                let binListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "BinListTableViewController") as! BinListTableViewController
               
                navigationController?.pushViewController(binListVC, animated: true)
                break
            case 2 :
                //create dirver
                let createDriverVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "CreateDriverViewController") as! CreateDriverViewController
                navigationController?.pushViewController(createDriverVC, animated: true)
                break
            case 3:
                // driver list
                let driverListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "DriverListViewController") as! DriverListViewController
               
                navigationController?.pushViewController(driverListVC, animated: true)
                break
            case 4:
                //complaint list
                let complaintListVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "ComplaintsListViewController") as! ComplaintsListViewController
                
            navigationController?.pushViewController(complaintListVC, animated: true)
                break
            case 5:
                //feedback
                let viewFeedbackVC = UIStoryboard(name:"Admin" , bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
              
            navigationController?.pushViewController(viewFeedbackVC, animated: true)
                break
            default:
                break
            }
        }
 
    func storedData() {
        let createBinObj = AdminDeshboardModel(title: "Create Bin", image: UIImage(named: "createBin") ?? UIImage())
        data.append(createBinObj)
        
        let binListObj = AdminDeshboardModel(title: "Bin List", image: UIImage(named: "createBin") ?? UIImage())
        data.append(binListObj)
        
        let createDriverObj = AdminDeshboardModel(title: "Create Driver", image: UIImage(named: "createDriver") ?? UIImage())
        data.append(createDriverObj)
        
        let driverListObj = AdminDeshboardModel(title: "Driver List", image: UIImage(named: "driverList") ?? UIImage())
        data.append(driverListObj)
        
        let complaintListObj = AdminDeshboardModel(title: "Complaint List", image: UIImage(named: "complaintList") ?? UIImage())
        data.append(complaintListObj)
        
        let feedbackListObj = AdminDeshboardModel(title: "Feedback List", image: UIImage(named: "viewFeedback") ?? UIImage())
        data.append(feedbackListObj)
    }

    
    @objc
    func pop() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.leftBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.leftView.frame.origin.x = -self.leftView.bounds.size.width
        }, completion: { _ in
            self.leftView.removeFromSuperview()
            self.leftBlurView.removeFromSuperview()
        })
    }

    @objc
    func add() {
       let vc = LeftMenuViewController()
       self.navigationController?.pushViewController(vc, animated: true)
    }

    func addChildeVC() {

        blurView = UIView()
        blurView.backgroundColor = .clear
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, at: 0)
        controller = LeftMenuViewController()
        addChild(controller)
        controller.view.frame = self.view.bounds
        controller.view.frame.origin.x = -self.view.bounds.size.width
        controller.menuBackDelegate  = self
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.blurView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.controller.view.frame.origin.x = 0
        }, completion: { _ in

        })
    }

    func removeChildeVC() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.controller.view.frame.origin.x = -self.view.bounds.size.width
            self.blurView.backgroundColor = .clear
        }, completion: { _ in
            self.controller.willMove(toParent: nil)
            self.controller.view.removeFromSuperview()
            self.controller.removeFromParent()
            self.blurView.removeFromSuperview()
        })
    }
    
    
    
}

extension AdminHomeScreenViewController: MemuBackDelegate {
    func back() {
        navConfige()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.blurView.backgroundColor = .clear
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }
}
