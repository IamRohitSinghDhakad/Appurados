//
//  FoodDetailVendorViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 11/09/21.
//

import UIKit

class FoodDetailVendorViewController: UIViewController {
    
    @IBOutlet var tblFoodDetails: UITableView!
    @IBOutlet weak var vwBtn: UIView!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet var vwCartDetails: UIView!
    
    var cell_FoodCategoryTableViewCell: FoodCategoryTableViewCell?
    
    var objVendorDetails: RestaurentsDetailModel?
    var arrSubCategory = [SubCategoryModel]()
    var arrProductDetails = [ProductDetailModel]()
    var arrShowSubCat = [String]()
    var arrAddress = [AddressModel]()
    
    var selectedCategoryID: Int = 0
    let selectedSubCategoryID: Int = 0
    
    var strCartCount = ""
    var strProductPrice = ""
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.call_WsGetSubCategory(strVendorID: objVendorDetails!.strVendorID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwCartDetails.isHidden = true
        self.call_WsGetAddress()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController")as! MyCartViewController
        vc.isComingFrom = "Detail"
        self.navigationController?.pushViewController(vc, animated: true)
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
        cell.lblFoodCatHeader.textColor = UIColor.init(named: "AppColor")
        let visibleRow = collectionView.indexPathsForVisibleItems.first
        if visibleRow != nil {
            print("Visible Row Index Path: \(visibleRow!), self.selectedCategoryID: \(self.selectedCategoryID), indexpath: \(indexPath.row)")
//            cell.lblFoodCatHeader.textColor = (self.selectedCategoryID == visibleRow!.row) ? UIColor.black : UIColor.init(named: "AppColor")
//            cell.lblFoodCatHeader.textColor = (visibleRow != nil) ? ((self.selectedCategoryID == visibleRow!.row) ? UIColor.black : UIColor.init(named: "AppColor")) : (self.selectedCategoryID == indexPath.row ? UIColor.black : UIColor.init(named: "AppColor"))
        }
        cell.lblFoodCatHeader.textColor = UIColor.init(named: "AppColor")
        if self.selectedCategoryID == indexPath.row{
            cell.lblFoodCatHeader.textColor = UIColor.black
        }else{
            cell.lblFoodCatHeader.textColor = UIColor.init(named: "AppColor")
        }
        
//        print("self.selectedCategoryID: \(self.selectedCategoryID)")
     //   cell.lblFoodCatHeader.textColor = (self.selectedCategoryID == indexPath.row ? UIColor.black : UIColor.init(named: "AppColor"))
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
            
            cell.btnFavUnfav.addTarget(self, action: #selector(btnFavUn(button:)), for: .touchUpInside)
           
             let profilePic = objVendorDetails?.strBannerImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                 if profilePic != "" {
                     let url = URL(string: profilePic!)
                    cell.imgVwVendor.sd_setImage(with: url, placeholderImage: nil)
                 }else{
                    cell.imgVwVendor.image = nil
                 }
             
            
            return cell
        }
        else {
            self.cell_FoodCategoryTableViewCell = self.tblFoodDetails.dequeueReusableCell(withIdentifier: "FoodCategoryTableViewCell") as! FoodCategoryTableViewCell
            return self.cell_FoodCategoryTableViewCell
        }
    }
    
    @objc func btnFavUn(button: UIButton){
        guard let vendorID = objVendorDetails?.strVendorID else { return }
        self.call_WsFavUnfavorite(strVendorID: vendorID)
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
        
        let subCat = self.arrShowSubCat[indexPath.row]
        if subCat.isEmpty {
            cell.lblSubCat.text = ""
            cell.vwSubCat.isHidden = true
        }
        else {
            cell.lblSubCat.text = subCat
            cell.vwSubCat.isHidden = false
        }
        
        cell.lblCategoryHeading.text = obj.strProductName
        cell.lblTitls.text = obj.strProduuctDescription
        cell.lblDescription.text = "$" + obj.strPrice
        
        let profilePic = obj.strProductImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if profilePic != "" {
            let url = URL(string: profilePic!)
            cell.imgVwDish.sd_setImage(with: url, placeholderImage: nil)
        }else{
            cell.imgVwDish.image = nil
        }
        
//        let indxPathVisibleCells = self.tblFoodDetails.indexPathsForVisibleRows
//        if indxPathVisibleCells != nil {
//            let indxP = indxPathVisibleCells!.first
//            let visibleObjIndexPath = self.arrProductDetails[indxP!.row]
//            let subcat = visibleObjIndexPath.strSubCategoryName
//            if let indexSubcat = self.arrSubCategory.firstIndex(where: {$0.strSubCategoryName == subcat}) {
//                self.selectedCategoryID = indexSubcat
//            }
//            else {
//                self.selectedCategoryID = 0
//            }
//        }
//        else {
//            self.selectedCategoryID = 0
//        }
//
//        print("Visible Index Path: \(self.selectedCategoryID)")
        
        /*
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
        else {
            self.selectedCategoryID = 0
        }
        */
        let collectionIndexSelected = IndexPath(item: self.selectedCategoryID, section: 0)
        print("collectionIndexSelected---->", self.selectedCategoryID)
        self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.reloadItems(at: [collectionIndexSelected])
        //self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.reloadData()
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblFoodDetails{
            
            let indxPathVisibleCells = self.tblFoodDetails.indexPathsForVisibleRows
            if indxPathVisibleCells != nil {
                if indxPathVisibleCells!.count > 0 {
                    let indxP = indxPathVisibleCells!.first
                    let visibleObjIndexPath = self.arrProductDetails[indxP!.row]
                    let subcat = visibleObjIndexPath.strSubCategoryName
                    if let indexSubcat = self.arrSubCategory.firstIndex(where: {$0.strSubCategoryName == subcat}) {
                        self.selectedCategoryID = indexSubcat
                    }
                    else {
                        self.selectedCategoryID = 0
                    }
                }
                else {
                    self.selectedCategoryID = 0
                }
            }
            else {
                self.selectedCategoryID = 0
            }
            
            print("Visible Index Path: \(self.selectedCategoryID)")
            let collectionIndexSelected = IndexPath(item: self.selectedCategoryID, section: 0)
       //     self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.reloadData()
        //    self.cell_FoodCategoryTableViewCell?.collectionFoodCategory.scrollToItem(at: collectionIndexSelected, at: .left, animated: true)
        }
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
                        if self.arrShowSubCat.contains(obj.strSubCategoryName) {
                            self.arrShowSubCat.append("")
                        }
                        else {
                            self.arrShowSubCat.append(obj.strSubCategoryName)
                        }
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
    
    
    
    func call_WsFavUnfavorite(strVendorID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dict = ["user_id":objAppShareData.UserDetail.strUserId,
                    "id":strVendorID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_FavUnfav, queryParams: [:], params: dict, strCustomValidation: "", showIndicator: false) { response in

       // objWebServiceManager.requestGet(strURL: WsUrl.url_FavUnfav, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
           
            
            if status == MessageConstant.k_StatusCode{

                if let result = response["result"]as? [String:Any]{
                    self.objVendorDetails?.isFavorite = true
                }
                self.tblFoodDetails.reloadData()
                
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.objVendorDetails?.isFavorite = false

                    self.tblFoodDetails.reloadData()
                   // self.call_WsMyFavList()
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


//Cart Detail
extension FoodDetailVendorViewController{
    //MARK:- Send Package
func call_WsCartDetail(strUserAddressID:String, strLat:String, strLong:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,"user_address_id":strUserAddressID]as [String:Any]
        
    objWebServiceManager.requestPost(strURL: WsUrl.url_GetCartDetails, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false){ (response) in
           objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    if arrData.count == 0{
                        self.vwCartDetails.isHidden = true
                    }else{
                        self.vwCartDetails.isHidden = false
                    }
                    self.strCartCount = "\(arrData.count)"
                    var finalproductPrice = Double()
                    
                    for data in arrData{
                        let productPrice = data["product_price"]as? String
                        let priceInDouble = Double(productPrice ?? "0.0")
                        finalproductPrice = finalproductPrice + priceInDouble!
                    }
                    
                    self.lblItem.text = self.strCartCount + " items $ \(finalproductPrice)"
                    
                }else{
                    if self.strCartCount == ""{
                        self.vwCartDetails.isHidden = true
                    }else{
                        self.vwCartDetails.isHidden = false
                    }
                    //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
                    objAlert.showAlert(message: "Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    if msgg == "Your Cart is Empty"{
                      
                    }else
                    {
                        objAlert.showAlert(message: msgg, title: "", controller: self)
                    }
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
          //  print(Error)
            objAlert.showAlert(message: "Failure!!", title: "Alert", controller: self)
            objWebServiceManager.hideIndicator()
        }
    }
    


func call_WsGetAddress(){
    
    if !objWebServiceManager.isNetworkAvailable(){
        objWebServiceManager.hideIndicator()
        objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        return
    }
    
    objWebServiceManager.showIndicator()
    
    let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
    
    objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserAddress, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
        objWebServiceManager.hideIndicator()
        
        let status = (response["status"] as? Int)
        let message = (response["message"] as? String)
        print(response)
        if status == MessageConstant.k_StatusCode{
        
            self.arrAddress.removeAll()
           
            
            if let result = response["result"]as? [[String:Any]]{
                
                for data in result{
                    let obj = AddressModel.init(dict: data)
                    self.arrAddress.append(obj)
                }
                var strAddressID = ""
                var lat = ""
                var long = ""
                
                if self.arrAddress.count != 0{
                    strAddressID = self.arrAddress[0].strUserAddressID
//                    self.lblDeliverTo.text = "Deliver to " + self.arrAddress[0].strAddress_name
//                    self.lblAddress.text = self.arrAddress[0].strAddress
                    lat = self.arrAddress[0].strLatitude
                    long = self.arrAddress[0].strLongitude
                }else{
                    strAddressID = self.arrAddress[0].strUserAddressID
                }
                self.call_WsCartDetail(strUserAddressID: strAddressID,strLat: lat,strLong: long)
              
               

            }
        }else{
            objWebServiceManager.hideIndicator()
            if let msgg = response["result"]as? String{
                objAlert.showAlert(message: msgg, title: "", controller: self)
                self.call_WsCartDetail(strUserAddressID: "0",strLat: "",strLong: "")
            }else{
                objAlert.showAlert(message: message ?? "", title: "", controller: self)
            }
        }
        
        
    } failure: { (Error) in
      //  print(Error)
        self.call_WsCartDetail(strUserAddressID: "0",strLat: "",strLong: "")
        objWebServiceManager.hideIndicator()
    }
    
    
}
}
