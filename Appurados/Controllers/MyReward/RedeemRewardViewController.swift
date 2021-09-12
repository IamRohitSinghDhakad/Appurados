//
//  RedeemRewardViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 12/09/21.
//

import UIKit

class RedeemRewardViewController: UIViewController {

    @IBOutlet var cvPromoCode: UICollectionView!
    
    var arrPromocode = [PromocodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvPromoCode.delegate = self
        self.cvPromoCode.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_WsGetOffers()
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
  
}

extension RedeemRewardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPromocode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RedeemRewardCollectionViewCell", for: indexPath)as! RedeemRewardCollectionViewCell
        
        let obj = self.arrPromocode[indexPath.row]
        let strStatus = obj.strPurchasedStatus
        
        
        let offerImg = obj.strPromocodeImage.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if offerImg != "" {
                let url = URL(string: offerImg!)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
            }
        
        cell.lblOfferDesc.text = "Buy this coupon in \(obj.strPoints) Points"
        
        if strStatus == "1"{
            cell.lblPromocode.text = obj.strPromocode
        }else{
            cell.lblPromocode.text = "Buy Now"
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size + 50 )
        
    }
    
}


extension RedeemRewardViewController{
    //MARK:- Category API
    func call_WsGetOffers(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let dict = ["offer_type":"Offer Voucher"]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPromoCode, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrData = response["result"]as? [[String:Any]]{
                    
                    for data in arrData{
                        let obj = PromocodeModel.init(dict: data)
                        self.arrPromocode.append(obj)
                    }
                    
                    self.cvPromoCode.reloadData()
                    
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

