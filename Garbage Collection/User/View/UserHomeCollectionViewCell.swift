//
//  UserHomeCollectionViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 06/08/22.
//

import UIKit

class UserHomeCollectionViewCell: UICollectionViewCell {
    static var identifier = "UserHomeCollectionViewCell"

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
