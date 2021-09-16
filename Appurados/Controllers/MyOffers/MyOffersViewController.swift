//
//  MyOffersViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class MyOffersViewController: UIViewController {

    @IBOutlet weak var tblOffers: UITableView!
    var arrPromocodeDiscountOffer = [PromocodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.call_WsGetOffers()
    }
    

    @IBAction func btnOpenSidemenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

}

//UItable vie delegates and datasorce
extension MyOffersViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPromocodeDiscountOffer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOfferTableViewCell")as! MyOfferTableViewCell
        
        let obj = self.arrPromocodeDiscountOffer[indexPath.row]
        
        let offerImg = obj.strPromocodeImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if offerImg != "" {
                let url = URL(string: offerImg!)
                cell.imgVwOffer.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        return cell
    }
    
}


extension MyOffersViewController{
    //MARK:- Category API
    func call_WsGetOffers(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let dict = ["offer_type":"Offer Discount"]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPromoCode, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = PromocodeModel.init(dict: data)
                        self.arrPromocodeDiscountOffer.append(obj)
                    }

                    self.tblOffers.reloadData()
                    
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
