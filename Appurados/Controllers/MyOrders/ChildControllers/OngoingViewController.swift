//
//  OngoingViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class OngoingViewController: UIViewController {

    @IBOutlet var tblOngoingOrderList: UITableView!
    
    
    var arrOngoingOrders = [OrdersDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblOngoingOrderList.delegate = self
        self.tblOngoingOrderList.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_WsGetOngoingOrder()
    }
    

}


//UITableView Delegates and DataSource
extension OngoingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOngoingOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingOrderListTableViewCell")as! PendingOrderListTableViewCell
        
        
        let obj = self.arrOngoingOrders[indexPath.row]
        cell.lblName.text = obj.strVendorName
        cell.lblTime.text = obj.strTimeAgo
        cell.lblPrice.text = "$" + obj.strPrice
        
        let profilePic = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        return cell
    }
}


//MARK:- Call Api
extension OngoingViewController{
    
    //MARK:- Vendor Count Product
    func call_WsGetOngoingOrder(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "status":"accept,shipped,accepted,picked"]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOrders, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = OrdersDetailModel.init(dict: data)
                        self.arrOngoingOrders.append(obj)
                    }
                    
                    
                    self.tblOngoingOrderList.reloadData()
                    
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
