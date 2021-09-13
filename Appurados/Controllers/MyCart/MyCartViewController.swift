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
    
    
    var arrCartItems = [CartItemsModel]()
    var strDistance = ""
    var strWallet = ""
    var strDileveryCharge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblOrders.delegate = self
        self.tblOrders.dataSource = self
        
        self.subVwConfirmation.isHidden = true
        self.call_WsCartDetail()
        
        // Do any additional setup after loading the view.
    }
    
    func setUserData(){
        self.lblDeliveryCharges.text = self.strDileveryCharge
        self.lblBasketTotal.text = self.strDileveryCharge
    }
    
    /// Manage Table vuew hight :----->
    override func viewWillLayoutSubviews() {
       // super.updateViewConstraints()
       // self.tblHgtConstant?.constant = self.tblOrders.contentSize.height + 50
        DispatchQueue.main.async {
            self.tblHgtConstant.constant = CGFloat((self.arrCartItems.count) * 100)//Here 30 is my cell height
             self.tblOrders.reloadData()
        }
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.lblDeliveryCharges.text = self.strDileveryCharge
    }
    
    @IBAction func btnOnChangeAddress(_ sender: Any) {
        self.pushVc(viewConterlerId: "ChangeAddressViewController")
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
        //self.subVwConfirmation.isHidden = false
    }
    @IBAction func btnOnCheckUncheckSpclReq(_ sender: Any) {
        
    }
    
    @IBAction func btnOnAddItems(_ sender: Any) {
        
    }
    
    @IBAction func btnOnCheckout(_ sender: Any) {
        
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
        return self.arrCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableViewCell")as! MyCartTableViewCell
        let obj = self.arrCartItems[indexPath.row]
        
        cell.lblFinalPrice.text = obj.strProductPrice//obj.strActualPrice
        cell.lblPrice.text = obj.strActualPrice
        cell.lblQuantity.text = obj.strQuantity
        cell.lblDishName.text = obj.strProductName
        
        let profilePic = obj.strProductImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        self.lblBasketTotal.text = obj.strProductPrice
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     //   self.viewWillLayoutSubviews()
    }
    
}


extension MyCartViewController {
    
        //MARK:- Send Package
        func call_WsCartDetail(){
            
            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
                return
            }
            objWebServiceManager.showIndicator()
            
            
            let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                             "user_address_id":""]as [String:Any]
            
            
            objWebServiceManager.requestGet(strURL: WsUrl.url_GetCartDetails, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
               objWebServiceManager.hideIndicator()
                print(response)
                let status = (response["status"] as? Int)
                let message = (response["message"] as? String)
                if status == MessageConstant.k_StatusCode{

                    if let arrData = response["result"]as? [[String:Any]]{
                        
                        if let distance = response["distance"]as? String{
                            self.strDistance = distance
                        }
                        
                        if let wallet = response["wallet"]as? String{
                            self.strWallet = wallet
                        }
                        
                        if let delivery_charge = response["delivery_charge"]as? String{
                            self.strDileveryCharge = delivery_charge
                        }else  if let delivery_charge = response["delivery_charge"]as? Int{
                            self.strDileveryCharge = "\(delivery_charge)"
                            
                        }
                        
                        for data in arrData{
                            let obj = CartItemsModel.init(dict: data)
                            self.arrCartItems.append(obj)
                        }
                        
                        self.tblOrders.reloadData()
                        self.viewWillLayoutSubviews()
                        self.setUserData()
                        
                    }else{
                        //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
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
