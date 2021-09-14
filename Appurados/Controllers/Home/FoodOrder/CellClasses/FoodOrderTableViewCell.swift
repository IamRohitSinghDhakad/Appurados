//
//  FoodOrderTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit

class FoodOrderTableViewCell: UITableViewCell {

    @IBOutlet var imgVwVendor: UIImageView!
    @IBOutlet var lblVendorName: UILabel!
    @IBOutlet var lblSpeciality: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var imgVeFav: UIImageView!
    @IBOutlet var vwRating: UIView!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet weak var btnFavUnfav: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
