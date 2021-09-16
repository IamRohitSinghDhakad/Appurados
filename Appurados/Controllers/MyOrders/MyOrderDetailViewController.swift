//
//  OrderDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 15/09/21.
//

import UIKit

class MyOrderDetailViewController: UIViewController {

    @IBOutlet weak var tblOrdersList: UITableView!
    @IBOutlet weak var lblBaskettotal: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var tblHgtConstant: NSLayoutConstraint!
    
    
    var strOrderID = ""
    var arrOrderDetail = [OrdersDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.call_WSGetOrderDetails(strOrderID: self.strOrderID)
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnOnTrackOrder(_ sender: Any) {
        self.pushVc(viewConterlerId: "TrackOrderViewController")
    }
    
}


extension MyOrderDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrOrderDetail.count != 0{
            let arrCount = self.arrOrderDetail[0].arrCart.count
            self.tblHgtConstant.constant = CGFloat((arrCount) * 115)
            return arrCount
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderDetailTableViewCell")as! MyOrderDetailTableViewCell
        
        let obj = self.arrOrderDetail[0].arrCart[indexPath.row]
        
        cell.lblDishName.text = obj.strCartProductName
        cell.lblPrice.text = "$" + obj.strCartAmount
        
        let profilePic = obj.strCartItemImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVwDish.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        return cell
    }
    

}

//MARK:- Call Webservice
extension MyOrderDetailViewController{

    //MARK:- Vendor Count Product
    func call_WSGetOrderDetails(strOrderID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "order_id":strOrderID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOrders, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = OrdersDetailModel.init(dict: data)
                        self.arrOrderDetail.append(obj)
                       
                    }
                    
                    if let data = response["result"]as? [[String:Any]]{
                        
                        if data.count != 0{
                            let obj = data[0]
                            
                            if let txn_amount = obj["txn_amount"]as? String{
                                self.lblBaskettotal.text = "$"+txn_amount
                            }else  if let txn_amount = obj["txn_amount"]as? Int{
                                self.lblBaskettotal.text = "$\(txn_amount)"
                                
                            }
                            
                            if let delivery_charge = obj["delivery_charge"]as? String{
                                self.lblDeliveryCharge.text = "$"+delivery_charge
                            }else  if let delivery_charge = obj["delivery_charge"]as? Int{
                                self.lblDeliveryCharge.text = "$\(delivery_charge)"
                            }
                            
                            if let sub_total = obj["sub_total"]as? String{
                                self.lblTotalAmount.text = "$"+sub_total
                            }else  if let sub_total = obj["sub_total"]as? Int{
                                self.lblTotalAmount.text = "$\(sub_total)"
                            }
                            
                            if let discount = obj["discount"]as? String{
                                self.lblDiscount.text = "$"+discount
                            }else  if let discount = obj["discount"]as? Int{
                                self.lblDiscount.text = "$\(discount)"
                            }
                            
                            
                        }
                        
                    }
                    
                    self.tblOrdersList.reloadData()
                    
                }else{
                    //self.btnAllRestaurents.setTitle("All Restaurents ", for: .normal)
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
