//
//  FeedbackTableViewCell.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 18/07/22.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
