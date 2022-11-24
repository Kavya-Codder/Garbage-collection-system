//
//  ListOfBinTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 26/07/22.
//

import UIKit

class ListOfBinTableViewCell: UITableViewCell {
    @IBOutlet weak var lblBinID: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblBinType: UILabel!
   @IBOutlet weak var lblCyclePeriod: UILabel!
    @IBOutlet weak var imgBin: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
