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
    var objProductDetails:ProductDetailModel?
    
    var strVendorID:String?
    var strProductID:String?
    
    var strProductprice:String?
    var strFinalPrice:String?
    var strAddonItemsID:String?
    var strQuantity:Float = 1
    var strVariantName:String?
    var strSelectedIndexAddOns = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblStepperQty.text = "\(Int(self.strQuantity))"
        self.vwContainerVarieant.isHidden = true
        
        self.tblvarient.delegate = self
        self.tblvarient.dataSource = self
        
        self.tblAddons.delegate = self
        self.tblAddons.dataSource = self
        
        self.strProductprice = self.objProductDetails?.strPrice
        self.strFinalPrice = self.objProductDetails?.strPrice
        
        
      //  self.call_WsGetOrderDetail(strVendorID: self.strVendorID ?? "", strProductID: self.strProductID ?? "")
        self.call_WsGetOrderDetail(strVendorID: self.objProductDetails?.strVendorID ?? "" , strProductID: self.objProductDetails?.strProductID ?? "")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblVarientHgtConstant?.constant = self.tblvarient.contentSize.height
        self.tblHgtConsAddOn?.constant = self.tblAddons.contentSize.height
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        if self.strQuantity > 0{
            self.strQuantity = self.strQuantity - 1
            guard let price = Float(self.strProductprice ?? "0") else { return }
           // let intPrice = Int(price)
            let finalPrice = price * strQuantity
            self.strFinalPrice = "\(finalPrice)"
            self.lblAddToCartAmount.text = "$ \(finalPrice)"
            self.lblStepperQty.text = "\(Int(self.strQuantity))"
        }else{
            self.lblStepperQty.text = "0"
        }
        
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        self.strQuantity = self.strQuantity + 1
        guard let price = Float(self.strProductprice ?? "0") else { return }
        let finalPrice = price * strQuantity
        print(finalPrice)
        self.lblAddToCartAmount.text = "$ \(finalPrice)"
        self.lblStepperQty.text = "\(Int(self.strQuantity))"
        self.strFinalPrice = "\(finalPrice)"
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnAddToCart(_ sender: Any) {
        
        var dictFilterSelectedOption = [String:Any]()
        var arrFilterd = [String]()
        
        for data in self.arrOrderDetail[0].arrVariant{
            
            let filterdValue = data.arrTypes.filter({$0.isSelected == true})
            if filterdValue.count == 0{
          
                self.strVariantName = ""
                
            }else{
               
                for data in filterdValue{
                    arrFilterd.append(data.strType)
                }
                let values = arrFilterd.joined(separator: ",")
             
                dictFilterSelectedOption["selectedValues"] = values
            
            }
        }
        
        let filterdValue = self.arrOrderDetail[0].arrAddonVariantName.filter({$0.isSelected == true})
        if filterdValue.count == 0{
      
            self.strVariantName = ""
            
        }else{
            var dictFilterSelectedOptionAddon = [String:Any]()
            var arrFilterdAddon = [String]()
            
            for data in filterdValue{
                arrFilterdAddon.append(data.strAddOnName)
            }
            let values = arrFilterdAddon.joined(separator: ",")
            dictFilterSelectedOptionAddon["selectedValues"] = values
            self.strAddonItemsID = dictFilterSelectedOptionAddon["selectedValues"]as? String ?? ""
        }
        
        self.strVariantName = dictFilterSelectedOption["selectedValues"]as? String ?? ""
      //  self.strAddonItemsID =
        
        
        self.call_WsAddToCart(strVendorID: self.strVendorID ?? "", strProductID: self.strProductID ?? "")
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
            
            if objVariant.isSelected == true{
                cell.imgVwradio.image = #imageLiteral(resourceName: "red")
            }else{
                cell.imgVwradio.image = #imageLiteral(resourceName: "radio")
            }
            
            return cell
        }
        if tableView == self.tblAddons{
            let cell = self.tblAddons.dequeueReusableCell(withIdentifier: "VarientTableViewCell")as! VarientTableViewCell
            
           // let objName = self.arrOrderDetail[0].arrAddOnName[indexPath.row]
            let objName = self.arrOrderDetail[0].arrAddonVariantName[indexPath.row]
            let objPrice = self.arrOrderDetail[0].arrAddOnPrice[indexPath.row]
            
            cell.lblVariantName.text = objName.strAddOnName
            cell.lblPrice.text = "$" + objPrice
            
            if objName.isSelected == true{
                cell.imgVwradio.image = #imageLiteral(resourceName: "red")
            }else{
                cell.imgVwradio.image = #imageLiteral(resourceName: "radio")
            }
            
            return cell
        }else{
            
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblvarient{
        let objVariant = self.arrOrderDetail[0].arrVariant[indexPath.section].arrTypes[indexPath.row]
        
        if objVariant.isSelected == true{
            objVariant.isSelected = false
        }else{
            objVariant.isSelected = true
        }
            self.tblvarient.reloadData()
        }else  if tableView == self.tblAddons{
            
            let obj = self.arrOrderDetail[0].arrAddonVariantName[indexPath.row]
            
            if obj.isSelected == true{
                obj.isSelected = false
            }else{
                obj.isSelected = true
            }
            
            self.tblAddons.reloadData()
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
        print(dicrParam)
        
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
    
    
    //MARK:- Add To cart
    
    
    //MARK:- Free Delivery
    func call_WsAddToCart(strVendorID:String, strProductID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":self.objProductDetails?.strVendorID ?? "",
                         "product_id":self.objProductDetails?.strProductID ?? "",
                         "price":self.strFinalPrice ?? "0.00",
                         "variant_name":self.strVariantName ?? "",
                         "addon_items":self.strAddonItemsID ?? "",
                         "quantity":"\(Int(self.strQuantity))",
                         "product_price":self.strProductprice ?? ""]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddToCart, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let result = response["result"]as? [String:Any]{
                    
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Order added on your cart!", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                   // objAlert.showAlert(message: "Order added succsfully in your cart", title: "Success", controller: self)

                    
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "Alert", controller: self)

                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
}
