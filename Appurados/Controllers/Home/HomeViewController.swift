//
//  HomeViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lblDeliverAddressHeader: UILabel!
    @IBOutlet weak var cvTopMenu: UICollectionView!
    @IBOutlet weak var cvSlider: UICollectionView!
    @IBOutlet weak var pageControllerSlider: UIPageControl!
    @IBOutlet weak var cvRecommendedProducts: UICollectionView!
    @IBOutlet var cvFreeDelivery: UICollectionView!
    @IBOutlet var cvPopularBrand: UICollectionView!
    @IBOutlet var cvOtherOffer: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDelegates()
        // Do any additional setup after loading the view.
    }
    
  /// ============================== ##### Setup Views ##### ==================================//
    func setDelegates(){
        
        self.cvSlider.delegate = self
        self.cvSlider.dataSource = self
        
        self.cvTopMenu.delegate = self
        self.cvTopMenu.dataSource = self
        
        self.cvRecommendedProducts.delegate = self
        self.cvRecommendedProducts.dataSource = self
        
        self.cvFreeDelivery.delegate = self
        self.cvFreeDelivery.dataSource = self
        
        self.cvPopularBrand.delegate = self
        self.cvPopularBrand.dataSource = self
        
        self.cvOtherOffer.delegate = self
        self.cvOtherOffer.dataSource = self
        
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnSearch(_ sender: Any) {
        
    }
    
    @IBAction func btnOnViewAllRastaurants(_ sender: Any) {
        pushVc(viewConterlerId: "FoodOrderViewController")
    }
    
  
}

/// ============================== ##### UICollectionView Delegates And Datasources ##### ==================================//

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cvTopMenu:
            return 4
        case cvSlider:
            return 4
        case cvRecommendedProducts:
            return 10
        case cvFreeDelivery:
            return 8
        case cvPopularBrand:
            return 8
        case cvOtherOffer:
            return 8
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.cvTopMenu{
            
            let cell = self.cvTopMenu.dequeueReusableCell(withReuseIdentifier: "HomeTopMenuCollectionViewCell", for: indexPath)as! HomeTopMenuCollectionViewCell
            
            
            
            return cell
            
            
        }else if collectionView == self.cvSlider{
            
            let cell =  self.cvSlider.dequeueReusableCell(withReuseIdentifier: "HomeSliderCollectionViewCell", for: indexPath)as! HomeSliderCollectionViewCell
            
            cell.imgVwSlider.allCorners()
            
            
            return cell
            
            
            
        }else if collectionView == self.cvRecommendedProducts{
            
            let cell = self.cvRecommendedProducts.dequeueReusableCell(withReuseIdentifier: "HomeRecommendedProductsCollectionViewCell", for: indexPath)as! HomeRecommendedProductsCollectionViewCell
            
            
            
            return cell
            
            
        }else if collectionView == self.cvFreeDelivery{
            
            let cell = self.cvFreeDelivery.dequeueReusableCell(withReuseIdentifier: "HomeFreeDeliveryCollectionViewCell", for: indexPath)as! HomeFreeDeliveryCollectionViewCell
            
            
            
            return cell
            
            
        }else if collectionView == self.cvPopularBrand{
            
            let cell = self.cvPopularBrand.dequeueReusableCell(withReuseIdentifier: "HomePopularBrandCollectionViewCell", for: indexPath)as! HomePopularBrandCollectionViewCell
            
            
            
            return cell
            
            
        }else if collectionView == self.cvOtherOffer{
            
            let cell = self.cvOtherOffer.dequeueReusableCell(withReuseIdentifier: "HomeOtherOfferCollectionViewCell", for: indexPath)as! HomeOtherOfferCollectionViewCell
            
            
            
            return cell
            
            
        }else{
            return UICollectionViewCell()
        }
    }
}


/// ============================== ##### UICollectionView Flow Layout Delegates And Datasources ##### ==================================//

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.cvTopMenu{
            let noOfCellsInRow = 3

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size )
            
        }else if collectionView == self.cvSlider{
            let noOfCellsInRow = 1

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
            
        }else if collectionView == self.cvRecommendedProducts{
            let noOfCellsInRow = 2.5

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size + 10)
        }else if collectionView == self.cvFreeDelivery{
            let noOfCellsInRow = 2

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
        }else if collectionView == self.cvPopularBrand{
            let noOfCellsInRow = 2.7

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
        }
        else if collectionView == self.cvOtherOffer{
            let noOfCellsInRow = 2

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
        }else{
            
            return CGSize(width: 200, height: 200)
        }

       
    }
    
}
