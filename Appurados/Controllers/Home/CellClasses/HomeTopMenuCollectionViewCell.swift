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
     
        self.imgVwTop.topCornersImgVw()
    }
}

///===================== ###### Free Delivery Collection View Cell Class ###### =======================//

class HomeFreeDeliveryCollectionViewCell: UICollectionViewCell {
    

    override func awakeFromNib() {
        
    }
}



extension UIImageView{
    
    func topCornersImgVw(){
        self.layer.masksToBounds = true
        self.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
