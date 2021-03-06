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
    @IBOutlet var vwSearchBar: UIView!
    @IBOutlet var tfSearchBar: UITextField!
    
    var arrAllRestaurants = [RestaurentsDetailModel]()
    var arrOfferCategory = [OfferCategoryModel]()
    var strCategoryIDForSearch = ""
    
    var strFree_delivery:String = ""
    var strHas_offers:String = ""
    var strPopular:String = ""
    var strRecommended:String = ""
    var strMy_favorite:String = ""
    var strOffer_category_id:String = ""
    var strMin_order_amount:String = ""
    var strNew_vendors:String = ""
    var strBest_rated = ""
    var strSelectedFilterValues = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwSearchBar.isHidden = true
    
        self.cvDishes.delegate = self
        self.cvDishes.dataSource = self
        
        self.tblRestaurents.delegate = self
        self.tblRestaurents.dataSource = self

        self.call_WsGetVendorList()
        self.call_WsGetOfferCategory()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    @IBAction func btnGoTOSearch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DishDetailViewController")as! DishDetailViewController
        vc.strCategoryID = self.strCategoryIDForSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

//    override func viewDidLayoutSubviews() {
//        tblRestaurents.heightAnchor.constraint(equalToConstant:
//        tblRestaurents.contentSize.height).isActive = true
//    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    

    @IBAction func btnOnFilter(_ sender: Any) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")as! FilterViewController
        vc.strTitle = "Filter"
        vc.isFromFilter = true
        vc.selectedValues = self.strSelectedFilterValues
        vc.closerForDictFilter = { dict
            in
            print(dict)
            if dict.count != 0{
                print(dict)
                
                self.strNew_vendors = ""
                self.strNew_vendors = ""
                self.strPopular = ""
                self.strBest_rated = ""
                self.strMy_favorite = ""
                self.strFree_delivery = ""
                
                let str = dict["selectedValues"]as? String
                self.strSelectedFilterValues = str ?? ""
                if str != nil{
                    if str!.contains("RESTAURANTS WITHOUT MINIMUM ORDER"){
                        print("RESTAURANTS WITHOUT MINIMUM ORDER")
                        self.strMin_order_amount = "0"
                    }
                    if str!.contains("NEW RESTAURANTS"){
                        print("NEW RESTAURANTS")
                        self.strNew_vendors = "1"
                    }
                    if str!.contains("RECOMMENDED RESTAURANTS"){
                        print("RECOMMENDED RESTAURANTS")
                        self.strPopular = "1"
                    }
                    if str!.contains("BEST RATED RESTAURANTS"){
                        print("BEST RATED RESTAURANTS")
                        self.strBest_rated = "1"
                    }
                    if str!.contains("RESTAURANT FAVORITES"){
                        print("RESTAURANT FAVORITES")
                        self.strMy_favorite = "1"
                    }
                    if str!.contains("FREE DELIVERY"){
                        print("FREE DELIVERY")
                        self.strFree_delivery = "1"
                    }
                }
               
                
                self.call_WsGetVendorList()
                
            }
        }
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    

    @IBAction func btnOnCuisines(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")as! FilterViewController
        vc.strTitle = "Cuisines"
        vc.isFromFilter = false
        vc.arrSubCategory = self.arrOfferCategory
        vc.closerForDictOfferCategory = { dict
            in
            if dict.count != 0{
                print(dict)
                self.strOffer_category_id = dict["selectedID"]as? String ?? ""
                print(self.strOffer_category_id)
                self.call_WsGetVendorList()
            }
        }
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnOnSearch(_ sender: Any) {
        
        if self.vwSearchBar.isHidden{
            self.vwSearchBar.isHidden = false
        }else{
            self.tfSearchBar.text = ""
            self.vwSearchBar.isHidden = true
        }
        
        
    }
}

/// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension FoodOrderViewController: UITableViewDelegate,UITableViewDataSource{
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tblHgtConstants.constant = CGFloat((self.arrAllRestaurants.count) * 100)
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
            cell.lblDistance.text = "Free Delivery"
        }else{
            cell.lblDistance.text = "$" + obj.strDeliverCharge + " (Service Charge)"
        }
        
        let profilePic = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwVendor.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        cell.btnFavUnfav.tag = indexPath.row
        cell.btnFavUnfav.addTarget(self, action: #selector(favBtnClick(button:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func favBtnClick(button: UIButton){
        print("Index = \(button.tag)")
        let vendorID = self.arrAllRestaurants[button.tag].strVendorID
        self.call_WsFavUnfavorite(strVendorID: vendorID, strIndex: button.tag)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailVendorViewController")as! FoodDetailVendorViewController
        vc.objVendorDetails = self.arrAllRestaurants[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    
    func call_WsFavUnfavorite(strVendorID:String, strIndex:Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dict = ["user_id":objAppShareData.UserDetail.strUserId,
                    "id":strVendorID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_FavUnfav, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                let obj = self.arrAllRestaurants[strIndex]
                if let result  = response["result"] as? [String:Any]{
                    obj.isFavorite = true
                }
                else {
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                self.tblRestaurents.reloadData()
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    let obj = self.arrAllRestaurants[strIndex]
                    obj.isFavorite = false
                    self.tblRestaurents.reloadData()
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Vendor Count Product
    func call_WsGetVendorList(){
        
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
                         "min_order_amount":self.strMin_order_amount,
                         "new_vendors":self.strNew_vendors,
                         "best_rated":self.strBest_rated,
                         "free_delivery":self.strFree_delivery,
                         "has_offers":self.strHas_offers,
                         "popular":self.strPopular,
                         "my_favorite":self.strMy_favorite,
                         "offer_category_id":self.strOffer_category_id,
                         "ios_register_id":""]as [String:Any]
      
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
          //  print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    self.arrAllRestaurants.removeAll()
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrAllRestaurants.append(obj)
                    }
                   
                    self.tblRestaurents.reloadData()
                    
                }else{
                  
                    objAlert.showAlert(message: "Data not found", title: "Alert", controller: self)
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
