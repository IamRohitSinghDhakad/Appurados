//
//  ChangeAddressViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 10/09/21.
//

import UIKit

class ChangeAddressViewController: UIViewController {

    @IBOutlet weak var tblAddress: UITableView!
    
    var arrAddress = [AddressModel]()
    
    var closerForDictAddress: (( _ strDict:AddressModel) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_WsGetAddress()
    }
    

    @IBAction func btnAddNewAddress(_ sender: Any) {
        self.pushVc(viewConterlerId: "AddNewAddressViewController")
    }

    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
}


extension ChangeAddressViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeAddressTableViewCell")as! ChangeAddressTableViewCell
        
        let obj = self.arrAddress[indexPath.row]
        
        cell.lblTypeAddress.text = "Deliver to \(obj.strAddress_name)"
        cell.lblAddress.text = obj.strAddress
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict  = self.arrAddress[indexPath.row]
        self.closerForDictAddress?(dict)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}


//Webserice call
extension ChangeAddressViewController{
    
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
                    self.tblAddress.reloadData()
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
