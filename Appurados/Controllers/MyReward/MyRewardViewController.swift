//
//  MyRewardViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class MyRewardViewController: UIViewController {

    @IBOutlet var tblRewardList: UITableView!
    @IBOutlet var lblTotalPoints: UILabel!
    
    var arrRewardList = [RewardModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRewardList.delegate = self
        self.tblRewardList.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_WsGetReward()
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnRedeemNow(_ sender: Any) {
        self.pushVc(viewConterlerId: "RedeemRewardViewController")
    }
}


extension MyRewardViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRewardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRewardTableViewCell")as! MyRewardTableViewCell
        
        let obj = self.arrRewardList[indexPath.row]
        
        cell.lblTitle.text = obj.strRemark
        cell.lblTimeAgo.text = obj.strTimeAgo
        cell.lblPoints.text = obj.strPoints + " points"
        
        return cell
    }

}


extension MyRewardViewController{
    
    //MARK:- Banner API
    func call_WsGetReward(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getRewards, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    var strTotalPoints:Int = 0
                    
                    for data in arrData{
                        let obj = RewardModel.init(dict: data)
                        if obj.strPoints != ""{
                            strTotalPoints = strTotalPoints + Int(obj.strPoints)!
                        }
                        self.arrRewardList.append(obj)
                    }
                    
                    self.lblTotalPoints.text = "\(strTotalPoints).00"
                    
                    self.tblRewardList.reloadData()
                    
                }else{
                    objAlert.showAlert(message: "Banner Data not found", title: "Alert", controller: self)
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
