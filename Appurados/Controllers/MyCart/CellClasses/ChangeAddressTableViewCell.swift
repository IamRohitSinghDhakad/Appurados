//
//  ChangeAddressTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/09/21.
//

import UIKit

class ChangeAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTypeAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSelectAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
