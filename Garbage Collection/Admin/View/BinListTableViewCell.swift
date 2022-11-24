//
//  BinListTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit

class BinListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblBinID: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblGarbageType: UILabel!
    @IBOutlet weak var lblAssignDriver: UILabel!
    @IBOutlet weak var lblCyclePeriod: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var editBin:(()->Void)?
    @IBAction func onClickEditBin(_ sender: UIButton) {
        editBin?()
    }
    
    var deletebin:(()->Void)?
    @IBAction func onClickDeleteBin(_ sender: UIButton) {
        deletebin?()
    }
    
}
