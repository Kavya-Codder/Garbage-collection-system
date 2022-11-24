//
//  DriverComplaintTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit

class DriverComplaintTableViewCell: UITableViewCell {
    @IBOutlet weak var lblBinID: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblComplaint: UILabel!
    @IBOutlet weak var lbluserName: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        lblStatus.layer.cornerRadius = 15
        lblStatus.clipsToBounds = true
        lblStatus.layer.borderWidth = 1
        lblStatus.layer.borderColor = UIColor.red.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
