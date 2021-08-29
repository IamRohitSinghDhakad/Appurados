//
//  SendPackageTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class SendPackageTableViewCell: UITableViewCell {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPickUpLocation: UILabel!
    @IBOutlet var lblDropLocation: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
