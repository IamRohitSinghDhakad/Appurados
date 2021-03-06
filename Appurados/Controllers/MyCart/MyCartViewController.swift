//
//  MyCartViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class MyCartViewController: UIViewController {

    @IBOutlet var tblHgtConstant: NSLayoutConstraint!
    @IBOutlet var tblOrders: UITableView!
    @IBOutlet var lblBasketTotal: UILabel!
    @IBOutlet var lblDeliveryCharges: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblDeliverTo: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var subVwConfirmation: UIView!
    @IBOutlet var lblNoOrderInCartMsg: UILabel!
    @IBOutlet weak var vwNoOrderIncart: UIView!
    @IBOutlet weak var imgVwChekBoxCutlery: UIImageView!
    @IBOutlet var btnBackOnHeader: UIButton!
    @IBOutlet weak var tfInstruction: UITextField!
    
    
    var arrCartItems = [CartItemsModel]()
    var strDistance = ""
    var strWallet = ""
    var strBasketTotal:Double = 0.0
    var strDileveryCharge = ""
    var arrAddress = [AddressModel]()
    var strAddressID = ""
    var objVendor:RestaurentsDetailModel?
    var strHoldActualPrice:Double = 0.0
    var dictCheckoutData = [String:Any]()
    var isComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwNoOrderIncart.isHidden = true
        self.imgVwChekBoxCutlery.image = #imageLiteral(resourceName: "box")
        self.tblOrders.delegate = self
        self.tblOrders.dataSource = self
      
        self.subVwConfirmation.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isComingFrom == "Detail"{
            self.btnBackOnHeader.setImage(UIImage.init(named: "back"), for: .normal)
        }else{
            self.btnBackOnHeader.setImage(UIImage.init(named: "menu"), for: .normal)
        }
        self.dictCheckoutData = [:]
        self.strBasketTotal = 0.0
        self.strDileveryCharge = ""
        self.call_WsGetAddress()
       
    }
    
    func setUserData(){
        self.lblDeliveryCharges.text = "$" + self.strDileveryCharge
        self.lblBasketTotal.text = "$" + self.strDileveryCharge
       // self.lblTotalAmount.text = "$" +
    }
    
    /// Manage Table vuew hight :----->
    override func viewWillLayoutSubviews() {
       // super.updateViewConstraints()
       // self.tblHgtConstant?.constant = self.tblOrders.contentSize.height + 50
//        DispatchQueue.main.async {
//            self.tblHgtConstant.constant = CGFloat((self.arrCartItems.count) * 100)//Here 30 is my cell height
//             self.tblOrders.reloadData()
//        }
//        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lblDeliveryCharges.text = "$" + self.strDileveryCharge
    }
    
    @IBAction func btnOnChangeAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAddressViewController")as! ChangeAddressViewController
        vc.closerForDictAddress = { dict
            in
           
            self.lblDeliverTo.text = "Deliver to \(dict.strAddress_name)"
            self.lblAddress.text = dict.strAddress
        }
        self.navigationController?.pushViewController(vc, animated: true)
      //  self.pushVc(viewConterlerId: "ChangeAddressViewController")
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        if isComingFrom == "Detail"{
            self.isComingFrom = ""
            self.navigationController?.popViewController(animated: true)
        }else{
            self.sideMenuController?.revealMenu()
        }
       
        //self.subVwConfirmation.isHidden = false
    }
    @IBAction func btnOnCheckUncheckSpclReq(_ sender: Any) {
        if imgVwChekBoxCutlery.image == #imageLiteral(resourceName: "box"){
            self.imgVwChekBoxCutlery.image = #imageLiteral(resourceName: "select")
        }else{
            self.imgVwChekBoxCutlery.image = #imageLiteral(resourceName: "box")
        }
    }
    
    @IBAction func btnOnAddItems(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailVendorViewController")as! FoodDetailVendorViewController
        vc.objVendorDetails = self.objVendor
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnCheckout(_ sender: Any) {
        
        self.dictCheckoutData["baketTotal"] = self.lblBasketTotal.text
        self.dictCheckoutData["deliveyCharge"] = self.lblDeliveryCharges.text
        self.dictCheckoutData["vendorID"] = self.objVendor?.strVendorID
        self.dictCheckoutData["addressID"] = self.strAddressID
        self.dictCheckoutData["instractions"] = self.tfInstruction.text
        self.dictCheckoutData["totalAmount"] = self.lblTotalAmount.text
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController")as! CheckOutViewController
        vc.dictData = self.dictCheckoutData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnCancelSubVw(_ sender: Any) {
        self.subVwConfirmation.isHidden = true
    }
    
    @IBAction func btnYesSubVw(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

/// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension MyCartViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tblHgtConstant.constant = CGFloat((self.arrCartItems.count) * 100)//Here 30 is my cell height
        return self.arrCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableViewCell")as! MyCartTableViewCell
        let obj = self.arrCartItems[indexPath.row]
        
        cell.lblFinalPrice.text = "$" + obj.strProductPrice
        cell.lblPrice.text = "$" + obj.strActualPrice
        cell.lblQuantity.text = obj.strQuantity
        
        if obj.strAddonItem != ""{
            cell.vwAddons.isHidden = false
            cell.lblAddons.text = "Addons:- " + obj.strAddonItem
    
            if obj.strVariantName != ""{
                cell.lblDishName.text = obj.strProductName + " \(obj.strVariantName)"
            }else{
                cell.lblDishName.text =  obj.strProductName
            }
            
        }else{
            cell.vwAddons.isHidden = true
            
            cell.lblDishName.text = obj.strProductName
            
            if obj.strVariantName != ""{
                cell.lblDishName.text = obj.strProductName + "\(obj.strVariantName)"
            }else{
                cell.lblDishName.text = obj.strProductName
            }
        }
        
        
        
        let profilePic = obj.strProductImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        self.strBasketTotal = self.strBasketTotal + Double(obj.strProductPrice)!
        self.lblBasketTotal.text = "$" + "\(self.strBasketTotal)"
//        //"\(self.strBasketTotal)"
//        self.strHoldActualPrice = self.strHoldActualPrice + (Double(obj.strProductPrice) ?? 0.0 + Double(self.strDileveryCharge)!)
//        self.lblTotalAmount.text = "$" +  "\(self.strHoldActualPrice)"
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrCartItems[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController")as! OrderDetailViewController
      //  vc.objProductDetails = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//     //   self.viewWillLayoutSubviews()
//    }
    
}


extension MyCartViewController {
    
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
                        self.vwNoOrderIncart.isHidden = true
                        if let distance = response["distance"]as? String{
                            self.strDistance = distance
                        }
                        
                        if let wallet = response["wallet"]as? String{
                            self.strWallet = wallet
                        }
                        
                        if let delivery_charge = response["delivery_charge"]as? String{
                            self.strDileveryCharge = delivery_charge
                            self.lblDeliveryCharges.text = delivery_charge
                        }else  if let delivery_charge = response["delivery_charge"]as? Int{
                            self.strDileveryCharge = "\(delivery_charge)"
                            self.lblDeliveryCharges.text = "\(delivery_charge)"
                        }
                        
                        self.lblTotalAmount.text = "\(Double(self.strBasketTotal) + Double(self.strDileveryCharge)!)"
                        
                        self.arrCartItems.removeAll()
                        var finalProductPrice = Double()
                        for data in arrData{
                            let obj = CartItemsModel.init(dict: data)
                            let productPrice = obj.strProductPrice
                            let priceInDouble = Double(productPrice)
                            finalProductPrice = finalProductPrice + priceInDouble!
                            self.arrCartItems.append(obj)
                        }
                        
                        self.lblTotalAmount.text = "$" + "\(finalProductPrice + Double(self.strDileveryCharge)!)"
                        
                        //"\(self.strBasketTotal)"
                       //        self.strHoldActualPrice = self.strHoldActualPrice + (Double(obj.strProductPrice) ?? 0.0 + Double(self.strDileveryCharge)!)
                       //        self.lblTotalAmount.text = "$" +  "\(self.strHoldActualPrice)"
                        
                        if self.arrCartItems.count != 0{
                            self.call_WsMyVendor(strVendorId: self.arrCartItems[0].strVendorID)
                        }
                       
                        self.tblOrders.reloadData()
                        self.viewWillLayoutSubviews()
                        self.setUserData()
                      //  self.call_WsGetDeliveryCharge(strPickLat: objAppShareData.UserDetail.strlatitude, strPickLong: objAppShareData.UserDetail.strlongitude, strDropLat: strLat, strDropLong: strLong)
                        
                    }else{
                        //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
                        objAlert.showAlert(message: "Data not found", title: "Alert", controller: self)
                    }
                }else{
                    objWebServiceManager.hideIndicator()
                    if let msgg = response["result"]as? String{
                        if msgg == "Your Cart is Empty"{
                            self.vwNoOrderIncart.isHidden = false
                            self.lblNoOrderInCartMsg.text = msgg
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
                    var lat = ""
                    var long = ""
                    if self.arrAddress.count != 0{
                        self.strAddressID = self.arrAddress[0].strUserAddressID
                        self.lblDeliverTo.text = "Deliver to " + self.arrAddress[0].strAddress_name
                        self.lblAddress.text = self.arrAddress[0].strAddress
                        lat = self.arrAddress[0].strLatitude
                        long = self.arrAddress[0].strLongitude
                    }else{
                        self.strAddressID = self.arrAddress[0].strUserAddressID
                    }
                    self.call_WsCartDetail(strUserAddressID: self.strAddressID,strLat: lat,strLong: long)
                  
                   

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
    
//    //MARK:- Send Package
//    func call_WsGetDeliveryCharge(strPickLat:String,strPickLong:String,strDropLat:String,strDropLong:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//        objWebServiceManager.showIndicator()
//
//
//        let dicrParam = ["pick_lat":strPickLat,
//                         "pick_lng":strPickLong,
//                         "drop_lat":strDropLat,
//                         "drop_lng":strDropLong]as [String:Any]
//
//
//
//        objWebServiceManager.requestGet(strURL: WsUrl.url_EstimateDeliveryCost, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
//           objWebServiceManager.hideIndicator()
//            print(response)
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//            if status == MessageConstant.k_StatusCode{
//
//                if let dictData = response["result"]as? [String:Any]{
//
//
//                    if let cost = dictData["cost"]as? String{
//                        self.lblDeliveryCharges.text = "$" + cost
//                    }else if let cost = dictData["cost"]as? Int{
//                        self.lblDeliveryCharges.text = "$\(cost)"
//                    }
//                    let cost = dictData["cost"]as? String ?? "0.0"
//
//                    self.lblTotalAmount.text = "$\(Double(self.strBasketTotal) + Double(cost)!)"
//
////                    if let distance = dictData["distance"]as? String{
////                        self.strDistance = distance
////                    }
//
////                    if let time = dictData["time"]as? String{
////                        self.strEstimatedTime = time
////                    }
////
//                }else{
//                    //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
//                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
//                }
//            }else{
//                objWebServiceManager.hideIndicator()
//                if let msgg = response["result"]as? String{
//                   // objAlert.showAlert(message: msgg, title: "", controller: self)
//                }else{
//                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
//                }
//            }
//        } failure: { (Error) in
//          //  print(Error)
//            objWebServiceManager.hideIndicator()
//        }
//    }
    
    
    //VendorDetails
    func call_WsMyVendor(strVendorId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":strVendorId,
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
            print(response)
            if status == MessageConstant.k_StatusCode{

             
                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = RestaurentsDetailModel.init(dict: data)
                        self.objVendor = obj
                       // self.arrVendor.append(obj)
                    }
                    
                 
                                        
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
    
}
