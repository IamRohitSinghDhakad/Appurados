//
//  PendingViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class PendingViewController: UIViewController {

    @IBOutlet var tblOrdersList: UITableView!
    var arrPendingOrders = [OrdersDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblOrdersList.delegate = self
        self.tblOrdersList.dataSource = self
        // Do any additional setup after loading the view.
        self.call_WsGetPendingOrder()
    }
    

}


//UITableView Delegates and DataSource
extension PendingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPendingOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingOrderListTableViewCell")as! PendingOrderListTableViewCell
        
        let obj = self.arrPendingOrders[indexPath.row]
        cell.lblName.text = obj.strVendorName
        cell.lblTime.text = obj.strTimeAgo
        cell.lblPrice.text = "$" + obj.strPrice
        
        let profilePic = obj.strRastaurentImg.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        cell.btnOpen.tag = indexPath.row
        cell.btnOpen.addTarget(self, action: #selector(openOrderDetail(button:)), for: .touchUpInside)
        
        cell.btnRepeat.tag = indexPath.row
        cell.btnRepeat.addTarget(self, action: #selector(repeatOrderDetail(button:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc func openOrderDetail(button: UIButton){
        print("Index = \(button.tag)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailViewController")as! MyOrderDetailViewController
        vc.strOrderID = self.arrPendingOrders[button.tag].strOrderID
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc func repeatOrderDetail(button: UIButton){
        print("Index = \(button.tag)")
       
    }

}


//MARK:- Call API
extension PendingViewController{
    
    
    //MARK:- Vendor Count Product
    func call_WsGetPendingOrder(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "status":"pending"]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetOrders, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
           objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{

                print(response)
                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = OrdersDetailModel.init(dict: data)
                        self.arrPendingOrders.append(obj)
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
