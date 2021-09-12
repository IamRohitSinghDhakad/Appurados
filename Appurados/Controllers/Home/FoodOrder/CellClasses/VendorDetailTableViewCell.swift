//
//  VendorDetailTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/09/21.
//

import UIKit

class VendorDetailTableViewCell: UITableViewCell {

    @IBOutlet var imgVwVendor: UIImageView!
    @IBOutlet var lblVendorName: UILabel!
    @IBOutlet var lblSpecilaity: UILabel!
    @IBOutlet var imgVwFav: UIImageView!
    @IBOutlet var btnFavUnfav: UIButton!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblFreeDelivery: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
