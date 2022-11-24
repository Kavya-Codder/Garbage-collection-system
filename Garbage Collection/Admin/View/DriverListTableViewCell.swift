//
//  DriverListTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit

class DriverListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDriverID: UILabel!
    @IBOutlet weak var lblAdharNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblAssignBin: UILabel!
    @IBOutlet weak var imgDriver: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgDriver.layer.cornerRadius = imgDriver.frame.height/2
        imgDriver.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    var editDriver:(()->Void)?
    @IBAction func onClickEditDriver(_ sender: UIButton) {
        editDriver?()
    }
    
    var deleteDriver:(()->Void)?
    @IBAction func onClickDeleteDriver(_ sender: UIButton) {
        deleteDriver?()
    }
    
}
