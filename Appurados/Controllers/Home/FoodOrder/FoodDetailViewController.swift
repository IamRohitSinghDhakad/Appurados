//
//  FoodDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 01/09/21.
//

import UIKit

class FoodDetailViewController: UIViewController {


    @IBOutlet var cvStickyHeader: UICollectionView!
    @IBOutlet var tblVwContent: UITableView!
    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet var tblHgtConstact: NSLayoutConstraint!
    
    var lastContentOffset = CGFloat()
    var strVendorID = ""
    
    var objVendorDetails: RestaurentsDetailModel?
    var arrSubCategoryID = [SubCategoryModel]()
    var arrProductDetails = [ProductDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvStickyHeader.delegate = self
        self.cvStickyHeader.dataSource = self
        
        self.tblVwContent.delegate = self
        self.tblVwContent.dataSource = self
        
        self.scrollVw.delegate = self
        
        self.call_WsGetSubCategory(strVendorID: objVendorDetails!.strVendorID)

    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHgtConstact?.constant = self.tblVwContent.contentSize.height
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
}


extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodDetailCollectionViewCell", for: indexPath)as! FoodDetailCollectionViewCell
        
        return cell
    }
    
    
    
}

extension FoodDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailTableViewCell")as! FoodDetailTableViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
}

extension FoodDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        print(self.lastContentOffset)
     //   let offset = scrollView.contentOffset.y
           if(lastContentOffset > 365){
              // self.cvStickyHeader.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100)
            var headerFrame = self.cvStickyHeader.frame
            headerFrame.origin.y = -50
            self.cvStickyHeader.frame = headerFrame//CGFloat(max(self.cvStickyHeader.frame.origin.y, scrollView.contentOffset.y))
            
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
           
           }else{
               self.cvStickyHeader.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100)
           }
        
//        print(self.lastContentOffset)
//        if self.lastContentOffset >= 365.0{
//            var headerFrame = self.cvStickyHeader.frame
//            headerFrame.origin.y = CGFloat(max(self.cvStickyHeader.frame.origin.y, scrollView.contentOffset.y))
//            self.cvStickyHeader.frame = headerFrame
//        }else{
//
//        }
        
        //        var headerFrame = self.cvStickyHeader.frame
        //        headerFrame.origin.y = CGFloat(max(self.cvStickyHeader.frame.origin.y, scrollView.contentOffset.y))
        //        self.cvStickyHeader.frame = headerFrame
    }
}


extension FoodDetailViewController{
    
    //MARK:- Free Delivery
    func call_WsGetGetVendorDetails(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":self.strVendorID,
                         "category_id":"",
                         "lat":objAppShareData.UserDetail.strlatitude,
                         "lng":objAppShareData.UserDetail.strlongitude,
                         "free_delivery":"",
                         "has_offers":"",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
         //   objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
//                    for data in arrData{
//                        let obj = RestaurentsDetailModel.init(dict: data)
//                        self.arrFreeDeliveryItem.append(obj)
//                    }
//                    self.call_WsGetRecomendedProduct()
//                    self.cvFreeDelivery.reloadData()
                    
                //    self.call_WsGetSubCategory()
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
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getSubCategory, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = SubCategoryModel.init(dict: data)
                        self.arrSubCategoryID.append(obj)
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
        print(dicrParam)
        
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
