//
//  NotificationViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tblNotifications: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblNotifications.delegate = self
        self.tblNotifications.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_WsGetNotificationList()
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
   
}


extension NotificationViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        
        
        return cell
    }
}



extension NotificationViewController{
    
    //MARK:- Banner API
    func call_WsGetNotificationList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Getnotification, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    var strTotalPoints:Int = 0
                    
                    for data in arrData{
                        let obj = NotificationModel.init(dict: data)
                        //self.arrRewardList.append(obj)
                    }
                    
                   
                    
                }else{
                    objAlert.showAlert(message: "Notification Data not found", title: "Alert", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
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
