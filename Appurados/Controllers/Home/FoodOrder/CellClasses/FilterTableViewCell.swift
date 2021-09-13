//
//  FilterTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh on 13/09/21.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwCheckUnCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
