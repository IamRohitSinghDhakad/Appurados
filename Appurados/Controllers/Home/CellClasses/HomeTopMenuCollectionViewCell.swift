//
//  HomeTopMenuCollectionViewCell.swift
//  Appurados
//
//  Created by Paras on 25/08/21.
//

import UIKit

class HomeTopMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        
    }
}


///===================== ###### Slider Collection View Cell Class ###### =======================//

class HomeSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVwSlider: UIImageView!
    
    override func awakeFromNib() {
        
    }
}


///===================== ###### Recommended Collection View Cell Class ###### =======================//

class HomeRecommendedProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgVwTop: UIImageView!
    @IBOutlet weak var imgVwRestaurant: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        
    }
}

