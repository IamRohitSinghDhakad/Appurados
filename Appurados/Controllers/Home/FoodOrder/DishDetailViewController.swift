//
//  DishDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit

class DishDetailViewController: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblRestaurents: UITableView!
    @IBOutlet var tfSearch: UITextField!
    
    var strCategoryID:String = ""
    var strtitle = ""
    
    var arrRestauranrts = [RestaurentsDetailModel]()
    var arrRestauranrtsFiltered = [RestaurentsDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRestaurents.delegate = self
        self.tblRestaurents.dataSource = self
        
        self.lblTitle.text = self.strtitle
        
        self.tfSearch.delegate = self
        self.tfSearch.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        self.call_WsGetRestaurants(strCategoryID: self.strCategoryID)
        
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
}


// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension DishDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRestauranrtsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOrderTableViewCell")as! FoodOrderTableViewCell
        
        let obj = self.arrRestauranrtsFiltered[indexPath.row]
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
    
}

//MARK:- Searching
extension DishDetailViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
     
        self.arrRestauranrtsFiltered.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.arrRestauranrts {
                let isMachingWorker : NSString = (dicData.strVendorName) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    arrRestauranrtsFiltered.append(dicData)
                }
            }
        } else {
            self.arrRestauranrtsFiltered = self.arrRestauranrts
        }
        if self.arrRestauranrtsFiltered.count == 0{
            self.tblRestaurents.displayBackgroundText(text: "No Record Found")
        }else{
            self.tblRestaurents.displayBackgroundText(text: "")
        }
        
            self.tblRestaurents.reloadData()
    }
}


extension DishDetailViewController{
    
    //MARK:- Free Delivery
    func call_WsGetRestaurants(strCategoryID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":"",
                         "category_id":strCategoryID,
                         "lat":"",
                         "lng":"",
                         "free_delivery":"1",
                         "has_offers":"",
                         "popular":"",
                         "my_favorite":"",
                         "offer_category_id":"",
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVendor, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.arrRestauranrts.append(obj)
                    }
                    
                    self.arrRestauranrtsFiltered = self.arrRestauranrts
                    
                    self.tblRestaurents.reloadData()
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
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
