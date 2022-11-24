//
//  UserHomeScreenViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 06/08/22.
//

import UIKit
struct UserDeshboardModel {
    let title: String
    let image: UIImage
}


class UserHomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var blurView = UIView()
    var leftView = UIView()
    var leftBlurView = UIView()
    var controller = LeftMenuViewController()
    
    var data:[UserDeshboardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Garbage Collector"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .white
        
        storedData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: UserHomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: UserHomeCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
               let cellWidth = (UIScreen.main.bounds.width - 110)/2
               layout.minimumLineSpacing = 20
               layout.minimumInteritemSpacing = 20
               layout.itemSize = CGSize(width: cellWidth, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 60, left: 45, bottom:10, right:45)
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
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: UserHomeCollectionViewCell.identifier, for: indexPath) as! UserHomeCollectionViewCell
      
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
//            my Complains
            let myComplainsVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "MyComplainsViewController") as! MyComplainsViewController
            
            navigationController?.pushViewController(myComplainsVC, animated: true)
            break
        case 1 :
            //add Complains
            let addComplainsVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "AddComplaintViewController") as! AddComplaintViewController
            navigationController?.pushViewController(addComplainsVC, animated: true)
            break
        case 2 :
            //profile
            let profileVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(identifier: "UserProfileViewController") as! UserProfileViewController
            navigationController?.pushViewController(profileVC, animated: true)
            break
        case 3:
            // feedback
            let feedbackVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserFeedbackViewController") as! UserFeedbackViewController
            navigationController?.pushViewController(feedbackVC, animated: true)
            break
        default:
            break
        }
    }
    
    func storedData() {
        let createBinObj = UserDeshboardModel(title: "My Complaines", image: UIImage(named: "myComplaintesIcon") ?? UIImage())
        data.append(createBinObj)
        
        let binListObj = UserDeshboardModel(title: "Add Complaint", image: UIImage(named: "addComplaintIcon") ?? UIImage())
        data.append(binListObj)
        
        let createDriverObj = UserDeshboardModel(title: "Profile", image: UIImage(named: "profileIcon") ?? UIImage())
        data.append(createDriverObj)
        
        let driverListObj = UserDeshboardModel(title: "Feedback", image: UIImage(named: "feedbackIcon") ?? UIImage())
        data.append(driverListObj)
        
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

extension UserHomeScreenViewController: MemuBackDelegate {
    func back() {
        navConfige()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.blurView.backgroundColor = .clear
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }
}
