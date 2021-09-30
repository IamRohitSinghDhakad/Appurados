//
//  FoodDetailVendorViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/09/21.
//

import UIKit

class FoodDetailVendorViewController: UIViewController {
    
    @IBOutlet var tblFoodDetails: UITableView!
    
    var cell_FoodCategoryTableViewCell: FoodCategoryTableViewCell?
    
    var objVendorDetails: RestaurentsDetailModel?
    var arrSubCategory = [SubCategoryModel]()
    var arrProductDetails = [ProductDetailModel]()
    
    var selectedCategoryID: Int = 0
    let selectedSubCategoryID: Int = 0
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.call_WsGetSubCategory(strVendorID: objVendorDetails!.strVendorID)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.onBackPressed()
    }
    
}

extension FoodDetailVendorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoryCollectionViewCell", for: indexPath) as! FoodCategoryCollectionViewCell
        
        let obj = self.arrSubCategory[indexPath.row]
        
        cell.lblFoodCatHeader.text = obj.strSubCategoryName
        let visibleRow = collectionView.indexPathsForVisibleItems.first
        print("Visible Row Index Path: \(visibleRow), self.selectedCategoryID: \(self.selectedCategoryID), indexpath: \(indexPath.row)")
        cell.lblFoodCatHeader.textColor = (visibleRow != nil) ? ((self.selectedCategoryID == visibleRow!.row) ? UIColor.black : UIColor.init(named: "AppColor")) : (self.selectedCategoryID == indexPath.row ? UIColor.black : UIColor.init(named: "AppColor"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryID = indexPath.row
        let obj = self.arrSubCategory[indexPath.row]
        if let objIndex = self.arrProductDetails.firstIndex(where: {$0.strSubCategoryName == obj.strSubCategoryName}) {
            let indxP = IndexPath(row: objIndex, section: 1)
            self.tblFoodDetails.scrollToRow(at: indxP, at: .top, animated: true)
        }
    }
    
}

extension FoodDetailVendorViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = self.tblFoodDetails.dequeueReusableCell(withIdentifier: "VendorDetailTableViewCell") as! VendorDetailTableViewCell
            
            
            if objVendorDetails?.isFavorite == true{
                cell.imgVwFav.image = #imageLiteral(resourceName: "heart")
            }else{
                cell.imgVwFav.image = #imageLiteral(resourceName: "like")
            }
            
            cell.lblVendorName.text = objVendorDetails?.strVendorName
            cell.lblSpecilaity.text = objVendorDetails?.strSpecialties
            cell.lblAddress.text = objVendorDetails?.strAddress
            cell.lblTimeForDeliver.text = "With in " + objVendorDetails!.strDistance + " mins"
            cell.lblDiscount.text = objVendorDetails?.strDiscountLabel
           
             let profilePic = objVendorDetails?.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                 if profilePic != "" {
                     let url = URL(string: profilePic!)
                    cell.imgVwVendor.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                 }
             
            
            return cell
        }
        else {
            self.cell_FoodCategoryTableViewCell = self.tblFoodDetails.dequeueReusableCell(withIdentifier: "FoodCategoryTableViewCell") as! FoodCategoryTableViewCell
            return self.cell_FoodCategoryTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 450
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        else {
            return self.arrProductDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblFoodDetails.dequeueReusableCell(withIdentifier: "FoodDetailTableViewCell", for: indexPath) as! FoodDetailTableViewCell
        
        let obj = self.arrProductDetails[indexPath.row]
        
        cell.lblCategoryHeading.text = obj.strProductName
        cell.lblTitls.text = obj.strProduuctDescription
        cell.lblDescription.text = "$" + obj.strPrice
        
        let profilePic = obj.strProductImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        let visibleRect = CGRect(origin: self.tblFoodDetails.contentOffset, size: self.tblFoodDetails.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = self.tblFoodDetails.indexPathForRow(at: visiblePoint)
        print("Visible Index Path: \(visibleIndexPath)")
        if visibleIndexPath != nil {
            let visibleObjIndexPath = self.arrProductDetails[visibleIndexPath!.row]
            let subcat = visibleObjIndexPath.strSubCategoryName
            if let indexSubcat = self.arrSubCategory.firstIndex(where: {$0.strSubCategoryName == subcat}) {
                self.selectedCategoryID = indexSubcat
            }
            
        }
        let collectionIndexSelected = IndexPath(item: self.selectedCategoryID, section: 0)
//        self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.reloadData()
        self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.scrollToItem(at: collectionIndexSelected, at: .left, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrProductDetails[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController")as! OrderDetailViewController
        vc.strVendorID = obj.strVendorID
        vc.strProductID = obj.strProductID
        vc.objProductDetails = obj
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension FoodDetailVendorViewController {
    
    //MARK:- Free Delivery
    func call_WsGetSubCategory(strVendorID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":strVendorID,
                         "category_id":"",
                         "lat":"",
                         "lng":"",
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getSubCategory, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = SubCategoryModel.init(dict: data)
                        self.arrSubCategory.append(obj)
                    }
              
//                    self.call_WsGetRecomendedProduct()
//                    self.cvFreeDelivery.reloadData()
                    self.call_WsGetAllProducts(strVendorID: strVendorID)
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
//                    self.call_WsGetRecomendedProduct()
//                    self.vwFreeDeliveryCV.isHidden = true
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
    
    
    //MARK:- Free Delivery
    func call_WsGetAllProducts(strVendorID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":strVendorID,
                         "category_id":"",
                         "lat":"",
                         "lng":"",
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getProduct, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = ProductDetailModel.init(dict: data)
                        self.arrProductDetails.append(obj)
                    }
                    
                    self.tblFoodDetails.reloadData()
                    if self.cell_FoodCategoryTableViewCell != nil {
                        self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.reloadData()
                    }
//                    self.call_WsGetRecomendedProduct()
//                    self.cvFreeDelivery.reloadData()
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
//                    self.call_WsGetRecomendedProduct()
//                    self.vwFreeDeliveryCV.isHidden = true
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
