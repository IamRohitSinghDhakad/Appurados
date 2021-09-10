//
//  HomeViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 24/08/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var lblDeliverAddressHeader: UILabel!
    @IBOutlet weak var cvTopMenu: UICollectionView!
    @IBOutlet weak var cvSlider: UICollectionView!
    @IBOutlet weak var pageControllerSlider: UIPageControl!
    @IBOutlet weak var cvRecommendedProducts: UICollectionView!
    @IBOutlet var cvFreeDelivery: UICollectionView!
    @IBOutlet var cvPopularBrand: UICollectionView!
    @IBOutlet var cvOtherOffer: UICollectionView!
    @IBOutlet var subVwMore: UIView!
    @IBOutlet var cvMore: UICollectionView!
    @IBOutlet var btnAllRestaurents: UIButton!
    
    @IBOutlet var vwPopularCV: UIView!
    @IBOutlet var vwOfferCV: UIView!
    @IBOutlet var vwFreeDeliveryCV: UIView!
    @IBOutlet var veRecomendedCV: UIView!
    
    
    var arrBannerData = [BannerModel]()
    var arrTempCategoryData = [CaterogryModel]()
    var arrCategoryData = [CaterogryModel]()
    var arrFreeDeliveryItem = [RestaurentsDetailModel]()
    var arrTotalRestaurents = [RestaurentsDetailModel]()
    var arrRecomendedItem = [ProductDetailModel]()
    var arrOfferItem = [RestaurentsDetailModel]()
    var arrFavoriteItem = [RestaurentsDetailModel]()
    var arrPopularItem = [RestaurentsDetailModel]()
    var x = 1
    var timer = Timer()
    
    //var arrTopMenu = ["Restaurantes", "Supermercado", "Mensajeria", "More"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDelegates()
        self.call_WsGetBanner()
        self.subVwMore.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    
  /// ============================== ##### Setup Views ##### ==================================//
    func setDelegates(){
        
        self.cvSlider.delegate = self
        self.cvSlider.dataSource = self
        
        self.cvTopMenu.delegate = self
        self.cvTopMenu.dataSource = self
        
        self.cvMore.delegate = self
        self.cvMore.dataSource = self
        
        self.cvRecommendedProducts.delegate = self
        self.cvRecommendedProducts.dataSource = self
        
        self.cvFreeDelivery.delegate = self
        self.cvFreeDelivery.dataSource = self
        
        self.cvPopularBrand.delegate = self
        self.cvPopularBrand.dataSource = self
        
        self.cvOtherOffer.delegate = self
        self.cvOtherOffer.dataSource = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.lblDeliverAddressHeader.text = objAppShareData.UserDetail.strAddress
        self.call_WsGetProfile()
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnSearch(_ sender: Any) {
        pushVc(viewConterlerId: "DishDetailViewController")
    }
    
    @IBAction func btnOnViewAllRastaurants(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodOrderViewController")as! FoodOrderViewController
        vc.arrAllRestaurants = arrTotalRestaurents
        self.navigationController?.pushViewController(vc, animated: true)
        //pushVc(viewConterlerId: "FoodOrderViewController")
    }
    @IBAction func btnCrossSubVw(_ sender: Any) {
        self.subVwMore.isHidden = true
    }
    
  
}

/// ============================== ##### UICollectionView Delegates And Datasources ##### ==================================//

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cvTopMenu:
            return self.arrTempCategoryData.count
        case cvMore:
            return self.arrCategoryData.count
        case cvSlider:
            let count = self.arrBannerData.count
            self.pageControllerSlider.numberOfPages = count
            self.pageControllerSlider.isHidden = !(count > 1)
            return count
        case cvRecommendedProducts:
            return self.arrRecomendedItem.count
        case cvFreeDelivery:
            return self.arrFreeDeliveryItem.count
        case cvPopularBrand:
            return self.arrPopularItem.count
        case cvOtherOffer:
            return self.arrOfferItem.count
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.cvTopMenu || collectionView == self.cvMore{
            
            let cell = self.cvTopMenu.dequeueReusableCell(withReuseIdentifier: "HomeTopMenuCollectionViewCell", for: indexPath)as! HomeTopMenuCollectionViewCell
            
            
            let obj:CaterogryModel?
            if collectionView == self.cvTopMenu{
                obj = self.arrTempCategoryData[indexPath.row]
                if indexPath.row == 3{
                    cell.lblTitle.text = "More"
                    cell.imgVw.image = #imageLiteral(resourceName: "menu-1")
                   // cell.lblTitle.text = "More"
                }else {
                    cell.lblTitle.text = obj?.strCategoryName
                    let profilePic = obj?.strCategoryImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        if profilePic != "" {
                            let url = URL(string: profilePic!)
                            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                        }
                }
                
            }else if collectionView == self.cvMore{
                obj = self.arrCategoryData[indexPath.row]
                
                cell.lblTitle.text = obj?.strCategoryName
                let profilePic = obj?.strCategoryImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if profilePic != "" {
                        let url = URL(string: profilePic!)
                        cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                    }
            }
            
            return cell
            
            
        }else if collectionView == self.cvSlider{
            
            let cell =  self.cvSlider.dequeueReusableCell(withReuseIdentifier: "HomeSliderCollectionViewCell", for: indexPath)as! HomeSliderCollectionViewCell
            
            let obj = self.arrBannerData[indexPath.row]
            
            if let user_image = obj.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) as? String{
                let profilePic = user_image
                if profilePic != "" {
                    let url = URL(string: profilePic)
                    cell.imgVwSlider.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            }else{
                cell.imgVwSlider.image = #imageLiteral(resourceName: "img")
            }
            
           // cell.imgVwSlider.allCorners()
            
            
            return cell
            
            
            
        }else if collectionView == self.cvRecommendedProducts{
            
            let cell = self.cvRecommendedProducts.dequeueReusableCell(withReuseIdentifier: "HomeRecommendedProductsCollectionViewCell", for: indexPath)as! HomeRecommendedProductsCollectionViewCell
            
            let obj = self.arrRecomendedItem[indexPath.row]
            
            cell.lblTitle.text = obj.strVendorName
            cell.lblPrice.text = obj.strMinimumOrderAmount + "$"
            cell.lblDescription.text = obj.strSpecialties
            
            
            let profilePic = obj.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if profilePic != "" {
                    let url = URL(string: profilePic!)
                    cell.imgVwTop.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            let restaurentImg = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if restaurentImg != "" {
                    let url = URL(string: restaurentImg!)
                    cell.imgVwRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            
            return cell
            
            
        }else if collectionView == self.cvFreeDelivery{
            
            let cell = self.cvFreeDelivery.dequeueReusableCell(withReuseIdentifier: "HomeFreeDeliveryCollectionViewCell", for: indexPath)as! HomeFreeDeliveryCollectionViewCell
            
            let obj = self.arrFreeDeliveryItem[indexPath.row]
            
            cell.lblRasturentName.text = obj.strVendorName
            cell.lblDistance.text = obj.strDistance
            cell.lblPrice.text = obj.strMinimumOrderAmount + "$"
            cell.lblDishes.text = obj.strSpecialties
            if obj.strDiscountLabel != ""{
                cell.vwOffPercentange.isHidden = false
                cell.lblOffPercentage.text = obj.strDiscountLabel
            }else{
                cell.vwOffPercentange.isHidden = true
            }
            
            
            let profilePic = obj.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if profilePic != "" {
                    let url = URL(string: profilePic!)
                    cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-1"))
                }
            
            let restaurentImg = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if restaurentImg != "" {
                    let url = URL(string: restaurentImg!)
                    cell.imgVwRastaurent.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            return cell
            
            
        }else if collectionView == self.cvPopularBrand{
            
            let cell = self.cvPopularBrand.dequeueReusableCell(withReuseIdentifier: "HomePopularBrandCollectionViewCell", for: indexPath)as! HomePopularBrandCollectionViewCell
            
            let obj = self.arrPopularItem[indexPath.row]
            
            cell.lblName.text = obj.strVendorName
            cell.lblTime.text = obj.strTime
            
            
            let restaurentImg = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if restaurentImg != "" {
                    let url = URL(string: restaurentImg!)
                    cell.imgVwRastaurent.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            return cell
            
            
        }else if collectionView == self.cvOtherOffer{
            
            let cell = self.cvOtherOffer.dequeueReusableCell(withReuseIdentifier: "HomeOtherOfferCollectionViewCell", for: indexPath)as! HomeOtherOfferCollectionViewCell
            
            let obj = self.arrOfferItem[indexPath.row]
            
            cell.lblRasturentName.text = obj.strVendorName
            cell.lblDistance.text = obj.strDistance
            cell.lblPrice.text = obj.strMinimumOrderAmount + "$"
            cell.lblDishes.text = obj.strSpecialties
            cell.vwRating.rating = Double(obj.strRating) ?? 0.0
            
            let profilePic = obj.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if profilePic != "" {
                    let url = URL(string: profilePic!)
                    cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            let restaurentImg = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if restaurentImg != "" {
                    let url = URL(string: restaurentImg!)
                    cell.imgVwRastaurent.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                }
            
            return cell
            
            
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  self.pushVc(viewConterlerId: "OrderDetailViewController")
        
        if collectionView == self.cvTopMenu{
            if indexPath.row == 3{
                self.subVwMore.isHidden = false
            }
        }
    }
}


/// ============================== ##### UICollectionView Flow Layout Delegates And Datasources ##### ==================================//

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.cvTopMenu || collectionView == self.cvMore{
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

            return CGSize(width: size, height: 160)
            
        }else if collectionView == self.cvRecommendedProducts{
            let noOfCellsInRow = 2.2

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size + 25)
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

            return CGSize(width: size, height: size + 20)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.cvSlider{
            self.pageControllerSlider?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        if scrollView == self.cvSlider{
            self.pageControllerSlider?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
       
    }
}

///Auto Scroll logic
extension HomeViewController{
   
    func setTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeViewController.autoScroll), userInfo: nil, repeats: true)
    }
   
    @objc func autoScroll() {
        if self.x < self.arrBannerData.count {
          let indexPath = IndexPath(item: x, section: 0)
          self.cvSlider.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
          self.x = self.x + 1
        }else{
          self.x = 0
          self.cvSlider.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}


//MARK:- Call APi Get get_banner
extension HomeViewController{
    
    //MARK:- Banner API
    func call_WsGetBanner(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBannerHome, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
          //  objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = BannerModel.init(dict: data)
                        self.arrBannerData.append(obj)
                    }
                    

                    self.cvSlider.reloadData()
                    
                    self.setTimer()
                    self.call_WsGetCategory()
                    
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
        
        
    }
    
    //MARK:- Category API
    func call_WsGetCategory(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.url_getCategory, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = CaterogryModel.init(dict: data)
                        self.arrCategoryData.append(obj)
                    }
                    
                    if self.arrCategoryData.count > 4{
                        let first3Index =  self.arrCategoryData[0..<4]
                        self.arrTempCategoryData.append(contentsOf: first3Index)
                        print(self.arrTempCategoryData)
                    }else{
                        self.arrTempCategoryData = self.arrCategoryData
                    }
                    
                    self.cvTopMenu.reloadData()
                    self.cvMore.reloadData()
                    self.call_WsGetFreeDelivery()
                    
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Free Delivery
    func call_WsGetFreeDelivery(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":"",
                         "lat":objAppShareData.UserDetail.strlatitude,
                         "lng":objAppShareData.UserDetail.strlongitude,
                         "free_delivery":"1",
                         "has_offers":"",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrFreeDeliveryItem.append(obj)
                    }
                    self.call_WsGetRecomendedProduct()
                    self.cvFreeDelivery.reloadData()
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.call_WsGetRecomendedProduct()
                    self.vwFreeDeliveryCV.isHidden = true
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Recomended Product
    func call_WsGetRecomendedProduct(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":"",
                         "lat":"",
                         "lng":"",
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"",
                         "recommended":"1",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getProduct, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = ProductDetailModel.init(dict: data)
                        self.arrRecomendedItem.append(obj)
                    }
                    self.call_WsGetPopularProduct()
                    self.cvRecommendedProducts.reloadData()
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.veRecomendedCV.isHidden = true
                    self.call_WsGetPopularProduct()
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //MARK:- Popular Product
    func call_WsGetPopularProduct(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":"",
                         "lat":objAppShareData.UserDetail.strlatitude,
                         "lng":objAppShareData.UserDetail.strlongitude,
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"1",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
          //  objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrPopularItem.append(obj)
                    }
                    self.call_WsGetOfferProduct()
                    self.cvPopularBrand.reloadData()
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.call_WsGetOfferProduct()
                    self.vwPopularCV.isHidden = true
                  //  objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Popular Product
    func call_WsGetOfferProduct(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":"",
                         "lat":objAppShareData.UserDetail.strlatitude,
                         "lng":objAppShareData.UserDetail.strlongitude,
                         "free_delivery":"",
                         "has_offers":"1",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
          //  objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrOfferItem.append(obj)
                    }
                    self.cvOtherOffer.reloadData()
                    self.call_WsGetVendorCount()
                    
                    let allCount = self.arrRecomendedItem.count + self.arrFreeDeliveryItem.count + self.arrPopularItem.count + self.arrOfferItem.count
                    self.btnAllRestaurents.setTitle("All \(allCount) Restaurents", for: .normal)
                    
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.vwOfferCV.isHidden = true
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Vendor Count Product
    func call_WsGetVendorCount(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":"",
                         "lat":"",
                         "lng":"",
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"",
                         "recommended":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
      
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrTotalRestaurents.append(obj)
                    }
                    
                    self.btnAllRestaurents.setTitle("All \(arrData.count) Restaurents ", for: .normal)
                    
                }else{
                    self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}



extension HomeViewController{
    
    func call_WsGetProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
       // objWebServiceManager.showIndicator()
        
        let dict = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getProfile, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
        //    objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_data  = response["result"] as? [String:Any]{

                    
                    
                   
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
