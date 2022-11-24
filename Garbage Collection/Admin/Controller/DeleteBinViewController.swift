//
//  DeleteBinViewController.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 09/08/22.
//

import UIKit

protocol DeleteDelegate:AnyObject {
    func deleteBin(index:Int)
}

class DeleteBinViewController: UIViewController {

    @IBOutlet weak var viewContaner: UIView!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    var index:Int?
    
    weak var deleate: DeleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    @IBAction func onClickYesBtn(_ sender: Any) {
        deleate?.deleteBin(index: index ?? -1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNoBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func initialSetup() {
        btnYes.layer.cornerRadius = 20
        btnYes.clipsToBounds = true
        
        btnNo.layer.cornerRadius = 20
        btnNo.clipsToBounds = true
        
        viewContaner.layer.cornerRadius = 30
        
    }
    
}
