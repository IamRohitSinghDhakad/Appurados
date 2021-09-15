//
//  OrderDetailTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh on 15/09/21.
//

import UIKit

class MyOrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVwDish: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVwDish.roundCorners(corners: [.bottomRight,.topRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
