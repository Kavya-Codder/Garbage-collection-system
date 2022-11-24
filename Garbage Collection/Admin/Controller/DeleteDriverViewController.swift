//
//  DeleteDriverViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 09/08/22.
//

import UIKit

protocol DeleteDriverDelegate: AnyObject {
    func deleteDriver(index:Int)
}

class DeleteDriverViewController: UIViewController {

    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    weak var delegate: DeleteDriverDelegate?
    var index:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
    }
    
    @IBAction func onClickYesBtn(_ sender: Any) {
        delegate?.deleteDriver(index: index ?? -1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNoBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialSetUp() {
        viewContainer.layer.cornerRadius = 30
        btnYes.layer.cornerRadius = 20
        btnYes.clipsToBounds = true
        
        btnNo.layer.cornerRadius = 20
        btnNo.clipsToBounds = true
    }
   
}
