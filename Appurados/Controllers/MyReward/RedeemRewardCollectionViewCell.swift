//
//  RedeemRewardCollectionViewCell.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 12/09/21.
//

import UIKit

class RedeemRewardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblOfferDesc: UILabel!
    @IBOutlet var lblPromocode: UILabel!
    @IBOutlet var btnBuyNow: UIButton!
    
    
    override func awakeFromNib() {
        self.imgVw.topCornersImgVw()
    }
    
}
