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
        self.imgVwSlider.layer.masksToBounds = true
        self.imgVwSlider.cornerRadius = 10
       // self.imgVwSlider.clipsToBounds = true
        self.imgVwSlider.viewShadowHeaderWithCorner(corner: 10)
       // self.imgVwSlider.allCorners()
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
    @IBOutlet weak var vwImgContainer: UIView!
    
    override func awakeFromNib() {
     
        self.imgVwTop.topCornersImgVw()
        self.imgVwRestaurant.applyshadowWithCorner(containerView: self.vwImgContainer, cornerRadious: 5)
    }
}

///===================== ###### Free Delivery Collection View Cell Class ###### =======================//

class HomeFreeDeliveryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgVwRastaurent: UIImageView!
    @IBOutlet var imgVwDish: UIImageView!
    @IBOutlet var lblOffPercentage: UILabel!
    @IBOutlet var vwOffPercentange: UIView!
    @IBOutlet var lblRasturentName: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDishes: UILabel!
    @IBOutlet var vwRating: FloatRatingView!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet weak var vwImgContainer: UIView!
    
    override func awakeFromNib() {
        self.imgVwDish.topCornersImgVw()
        self.imgVwRastaurent.applyshadowWithCorner(containerView: self.vwImgContainer, cornerRadious: 5)
    }
}

///===================== ######Popular Brand Collection View Cell Class ###### =======================//

class HomePopularBrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imgVwRastaurent: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblName: UILabel!
    

    override func awakeFromNib() {
        self.imgVwRastaurent.allCorners()
    }
}


///===================== ######Other Offer Collection View Cell Class ###### =======================//

class HomeOtherOfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgVwRastaurent: UIImageView!
    @IBOutlet var imgVwDish: UIImageView!
    @IBOutlet var lblRasturentName: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDishes: UILabel!
    @IBOutlet var vwRating: FloatRatingView!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet weak var vwImgContainer: UIView!
    
    
    override func awakeFromNib() {
        self.imgVwDish.topCornersImgVw()
        self.imgVwRastaurent.applyshadowWithCorner(containerView: self.vwImgContainer, cornerRadious: 5)
    }
}



extension UIImageView{
    
    func topCornersImgVw(){
        self.layer.masksToBounds = true
        self.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func rightsideCornersOnly(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
       // self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    
    func allCorners(){
      //  self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
