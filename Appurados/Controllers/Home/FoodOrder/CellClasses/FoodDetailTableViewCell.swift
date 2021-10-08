//
//  FoodDetailTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 01/09/21.
//

import UIKit

class FoodDetailTableViewCell: UITableViewCell {

    @IBOutlet var lblCategoryHeading: UILabel!
    @IBOutlet var lblTitls: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgVwDish: UIImageView!
    
    @IBOutlet weak var vwSubCat: UIView!
    @IBOutlet weak var lblSubCat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
