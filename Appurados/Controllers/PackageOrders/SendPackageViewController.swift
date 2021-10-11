//
//  SendPackageViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class SendPackageViewController: UIViewController {

    @IBOutlet var tblSendPackageList: UITableView!
    
    var arrSendPackage = [SendPackageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSendPackageList.delegate = self
        self.tblSendPackageList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_WsSendPackage()
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
       
    }
    
}

extension SendPackageViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSendPackage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendPackageTableViewCell")as! SendPackageTableViewCell
        
        let obj = self.arrSendPackage[indexPath.row]
        cell.lblPrice.text = "$" + obj.strAmount
        cell.lblName.text = obj.strReceiver_name
        cell.lblStatus.text = obj.strStatus
        cell.lblPickUpLocation.text = obj.strPick_address
        cell.lblDropLocation.text = obj.strDrop_address
        
        let profilePic = obj.strUser_image.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if profilePic != "" {
                let url = URL(string: profilePic!)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        
        return cell
        
    }
}

extension SendPackageViewController {
    
        //MARK:- Send Package
        func call_WsSendPackage(){
            
            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
                return
            }
            objWebServiceManager.showIndicator()
            
            
            let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                             "status":""]as [String:Any]
            
            
            objWebServiceManager.requestGet(strURL: WsUrl.url_GetPackageDelivery, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
               objWebServiceManager.hideIndicator()
                print(response)
                let status = (response["status"] as? Int)
                let message = (response["message"] as? String)
                if status == MessageConstant.k_StatusCode{

                    if let arrData = response["result"]as? [[String:Any]]{
                        
                        for data in arrData{
                            let obj = SendPackageModel.init(dict: data)
                            self.arrSendPackage.append(obj)
                        }
                        
                        self.tblSendPackageList.reloadData()
                        
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
