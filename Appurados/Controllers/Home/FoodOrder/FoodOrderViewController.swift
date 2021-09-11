//
//  FoodOrderViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit

class FoodOrderViewController: UIViewController {

    @IBOutlet var cvDishes: UICollectionView!
    @IBOutlet var tblRestaurents: UITableView!
    @IBOutlet var tblHgtConstants: NSLayoutConstraint!
    
    var arrAllRestaurants = [RestaurentsDetailModel]()
    var arrOfferCategory = [OfferCategoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvDishes.delegate = self
        self.cvDishes.dataSource = self
        
        self.tblRestaurents.delegate = self
        self.tblRestaurents.dataSource = self

        self.call_WsGetOfferCategory()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHgtConstants?.constant = self.tblRestaurents.contentSize.height
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    

    @IBAction func btnOnFilter(_ sender: Any) {
        
    }
    

    @IBAction func btnOnCuisines(_ sender: Any) {
        
        
    }
    
    @IBAction func btnOnSearch(_ sender: Any) {
        
    }
}

/// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension FoodOrderViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOrderTableViewCell")as! FoodOrderTableViewCell
        
        let obj = self.arrAllRestaurants[indexPath.row]
        cell.lblVendorName.text = obj.strVendorName
        cell.lblSpeciality.text = obj.strSpecialties
        cell.lblTime.text = obj.strTime
        
        cell.lblRating.text = obj.strRating
        if obj.isFavorite{
            cell.imgVeFav.image = #imageLiteral(resourceName: "heart")
        }else{
            cell.imgVeFav.image = #imageLiteral(resourceName: "like")
        }
        
        if obj.strFreeDelivery == "1"{
            cell.lblDistance.text = "(Free Delivery)"
        }else{
            cell.lblDistance.text = obj.strDistance
        }
        
        let profilePic = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwVendor.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.pushVc(viewConterlerId: "FoodDetailViewController")
       // self.pushVc(viewConterlerId: "OrderDetailViewController")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
}

/// ============================== ##### UICollectionView Delegates And Datasources ##### ==================================//

extension FoodOrderViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfferCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishesCollectionViewCell", for: indexPath)as! DishesCollectionViewCell
        
        let obj = self.arrOfferCategory[indexPath.row]
        
        cell.lblOfferFood.text = obj.strOffer_category_name
        
        let profilePic = obj.strOffer_category_image.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgvw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pushVc(viewConterlerId: "DishDetailViewController")
    }
}


/// ============================== ##### UICollectionView Flow Layout Delegates And Datasources ##### ==================================//

extension FoodOrderViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 4.5

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size )
            
        
    }
}

/// ============================== ##### get_offer_category  ##### ==================================//
extension FoodOrderViewController{
    
    func call_WsGetOfferCategory(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
       // let dict = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOfferCategory, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_data  = response["result"] as? [[String:Any]]{

                    for data in user_data{
                        let obj = OfferCategoryModel.init(dict: data)
                        self.arrOfferCategory.append(obj)
                    }
                    
                    self.cvDishes.reloadData()
                   
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
