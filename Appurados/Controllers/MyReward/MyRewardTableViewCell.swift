//
//  MyRewardTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class MyRewardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
