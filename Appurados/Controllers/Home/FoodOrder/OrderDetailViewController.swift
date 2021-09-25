//
//  OrderDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 31/08/21.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var imgVwDish: UIImageView!
    @IBOutlet weak var tblVarientHgtConstant: NSLayoutConstraint!
    @IBOutlet weak var tblvarient: UITableView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var tblAddons: UITableView!
    @IBOutlet weak var tblHgtConsAddOn: NSLayoutConstraint!
    @IBOutlet weak var vwContainerVarieant: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddToCartAmount: UILabel!
    @IBOutlet weak var lblStepperQty: UILabel!
    @IBOutlet weak var lblDishType: UILabel!
    
    var arrOrderDetail = [OrderDetailModel]()
    
    
    var strVendorID:String?
    var strProductID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwContainerVarieant.isHidden = true
        
        self.tblvarient.delegate = self
        self.tblvarient.dataSource = self
        
        self.tblAddons.delegate = self
        self.tblAddons.dataSource = self
        
        self.call_WsGetOrderDetail(strVendorID: self.strVendorID ?? "", strProductID: self.strProductID ?? "")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblVarientHgtConstant?.constant = self.tblvarient.contentSize.height
        self.tblHgtConsAddOn?.constant = self.tblAddons.contentSize.height
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        
    }
    @IBAction func btnPlus(_ sender: Any) {
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    

}


extension OrderDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrOrderDetail.count > 0{
            if tableView == tblvarient{
                return self.arrOrderDetail[0].arrVariant.count
            }else if tableView == tblAddons{
                return 1
            }else{
                return 0
            }
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblvarient{
            let variantName = self.arrOrderDetail[0].arrVariant[section].strVariant
            return variantName
        }else{
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = .clear //use any color you want here .red, .black etc
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblvarient{
            let obj = self.arrOrderDetail[0].arrVariant
            return obj[section].arrTypes.count
        }else if tableView == tblAddons{
            return self.arrOrderDetail[0].arrAddOnName.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblvarient{
            let cell = self.tblvarient.dequeueReusableCell(withIdentifier: "VarientTableViewCell")as! VarientTableViewCell
            
            let objVariant = self.arrOrderDetail[0].arrVariant[indexPath.section].arrTypes[indexPath.row]
            cell.lblVariantName.text = objVariant.strType
            cell.lblPrice.text = objVariant.strPrice
            
            return cell
        }
        if tableView == self.tblAddons{
            let cell = self.tblAddons.dequeueReusableCell(withIdentifier: "VarientTableViewCell")as! VarientTableViewCell
            
            let objName = self.arrOrderDetail[0].arrAddOnName[indexPath.row]
            let objPrice = self.arrOrderDetail[0].arrAddOnPrice[indexPath.row]
            
            cell.lblVariantName.text = objName
            cell.lblPrice.text = "$" + objPrice
            
            return cell
        }else{
            
            return UITableViewCell()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension OrderDetailViewController{
    
    //MARK:- Free Delivery
    func call_WsGetOrderDetail(strVendorID:String, strProductID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":strVendorID,
                         "product_id":strProductID,
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
                    print(arrData.count)
                        for data in arrData{
                            let obj = OrderDetailModel.init(dict: data)
                            self.arrOrderDetail.append(obj)
                        }
                    
                    if self.arrOrderDetail.count == 0{
                        
                    }else{
                        let obj = self.arrOrderDetail[0]
                        
                        self.lblDescription.text = obj.strProduuctDescription
                        self.lblDishName.text = obj.strProductName
                        self.lblAmount.text = "$" + obj.strPrice
                        self.lblDishType.text = obj.strProductType
                        self.lblAddToCartAmount.text = "$" + obj.strPrice
                        
                        let profilePic = obj.strProductImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            if profilePic != "" {
                                let url = URL(string: profilePic!)
                                self.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
                            }
                    }
                    
                    self.tblvarient.reloadData()
                    self.tblAddons.reloadData()
                    
                    if self.arrOrderDetail[0].arrVariant.count == 0 && self.arrOrderDetail[0].arrAddOnName.count == 0 {
                        self.vwContainerVarieant.isHidden = true
                    }else{
                        self.vwContainerVarieant.isHidden = false
                    }
                    self.viewWillLayoutSubviews()
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
            objWebServiceManager.hideIndicator()
        }
    }
    
}
