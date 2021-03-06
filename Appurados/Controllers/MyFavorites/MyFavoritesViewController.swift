//
//  MyFavoritesViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class MyFavoritesViewController: UIViewController {

    @IBOutlet var tblRestaurents: UITableView!
    @IBOutlet var tfSearch: UITextField!
    
    var arrFavList = [RestaurentsDetailModel]()
    var arrFavListFiltered = [RestaurentsDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRestaurents.delegate = self
        self.tblRestaurents.dataSource = self
        
        self.tfSearch.delegate = self
        self.tfSearch.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_WsMyFavList()
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension MyFavoritesViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavListFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOrderTableViewCell")as! FoodOrderTableViewCell
        
        let obj = self.arrFavListFiltered[indexPath.row]
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
        self.tfSearch.text = ""
        self.view.endEditing(true)
        let vendorID = self.arrFavListFiltered[button.tag].strVendorID
        self.call_WsFavUnfavorite(strVendorID: vendorID, strIndex: button.tag)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrFavListFiltered[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailVendorViewController")as! FoodDetailVendorViewController
        vc.objVendorDetails = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}

//MARK:- Searching
extension MyFavoritesViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
     
        self.arrFavListFiltered.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.arrFavList {
                let isMachingWorker : NSString = (dicData.strVendorName) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    arrFavListFiltered.append(dicData)
                }
            }
        } else {
            self.arrFavListFiltered = self.arrFavList
        }
        if self.arrFavListFiltered.count == 0{
            self.tblRestaurents.displayBackgroundText(text: "No Record Found")
        }else{
            self.tblRestaurents.displayBackgroundText(text: "")
        }
        
            self.tblRestaurents.reloadData()
    }
}

extension MyFavoritesViewController{
    //MARK:- Vendor Count Product
    func call_WsMyFavList(){
        
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
                         "my_favorite":"1",
                         "offer_category_id":"",
                         "ios_register_id":""]as [String:Any]
      
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                self.arrFavList.removeAll()
                self.arrFavListFiltered.removeAll()
                
                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrFavList.append(obj)
                    }
                    
                    print("=================>>>> ",self.arrFavList.count)
                    self.arrFavListFiltered = self.arrFavList
                    self.tblRestaurents.reloadData()
                                        
                }else{
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
          //  objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
           
            
            if status == MessageConstant.k_StatusCode{
               // let obj = self.arrAllRestaurants[strIndex]
//                if let result  = response["result"] as? [String:Any]{
//                    obj.isFavorite = true
//                }
//                else {
//                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
//                }
             //   self.tblRestaurents.reloadData()
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                  //  let obj = self.arrAllRestaurants[strIndex]
                   // obj.isFavorite = false
                   // self.tblRestaurents.reloadData()
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
                    self.call_WsMyFavList()
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
