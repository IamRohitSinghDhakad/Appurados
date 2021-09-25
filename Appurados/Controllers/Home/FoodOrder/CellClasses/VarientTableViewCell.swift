//
//  VarientTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh on 31/08/21.
//

import UIKit

class VarientTableViewCell: UITableViewCell {

    @IBOutlet weak var lblVariantName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVwradio: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
