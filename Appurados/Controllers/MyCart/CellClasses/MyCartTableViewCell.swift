//
//  MyCartTableViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {

    @IBOutlet var imgVwDish: UIImageView!
    @IBOutlet var lblDishName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblFinalPrice: UILabel!
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet weak var lblAddons: UILabel!
    @IBOutlet var vwAddons: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.imgVwDish.layer.masksToBounds = true
        self.imgVwDish.roundCorners(corners: [.bottomRight,.topRight], radius: 10)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
