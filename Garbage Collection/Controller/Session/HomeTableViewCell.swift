//
//  HomeTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 29/07/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var homeImgView: UIImageView!
    @IBOutlet weak var homeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
