//
//  CheckOutViewController.swift
//  Appurados
//
//  Created by Rohit Dhakad on 08/10/21.
//

import UIKit


class CheckOutViewController: UIViewController {
    
    @IBOutlet weak var tfCoupon: UITextField!
    @IBOutlet weak var imgVwOnline: UIImageView!
    @IBOutlet weak var imgVwCash: UIImageView!
    @IBOutlet weak var lblBasketTotal: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    
    var dictData = [String:Any]()
  
    
    var basketTotal = ""
    var deliveryCharge = ""
    var vendorID = ""
    var addressID = ""
    var instruction = ""
    var paymentMode = ""
    var strPromocodeID = ""
    var strDiscountAmount = ""
    var strFinalAmount = ""
    var min_amount:Double = 0.0
    var main_amount:Double = 0.0
    var strOrderID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentMode = "cash"
        self.imgVwCash.image = #imageLiteral(resourceName: "select")
        self.strDiscountAmount = ""
        self.basketTotal =  self.dictData["baketTotal"] as? String ?? ""
        self.deliveryCharge = self.dictData["deliveyCharge"] as? String ?? ""
        self.vendorID = self.dictData["vendorID"] as? String ?? ""
        self.addressID = self.dictData["addressID"] as? String ?? ""
        self.instruction = self.dictData["instractions"] as? String ?? ""
        self.lblBasketTotal.text = self.basketTotal
        self.lblDeliveryCharge.text = self.deliveryCharge
        self.lblFinalAmount.text =  self.dictData["totalAmount"] as? String ?? ""
        let fianl = self.dictData["totalAmount"] as? String ?? ""
        self.main_amount = Double(fianl.removeFormatAmount()) 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnOnline(_ sender: Any) {
        self.imgVwCash.image = #imageLiteral(resourceName: "box")
        self.imgVwOnline.image = #imageLiteral(resourceName: "select")
    }
    
    @IBAction func btnCash(_ sender: Any) {
        self.imgVwCash.image = #imageLiteral(resourceName: "select")
        self.imgVwOnline.image = #imageLiteral(resourceName: "box")
    }
    
    @IBAction func btnApplyCoupon(_ sender: Any) {
        self.call_WsBuyOffer(strPromocode: self.tfCoupon.text!)
    }
    
    @IBAction func btnPlaceOrder(_ sender: Any) {
        self.call_WsPlaceOrder()
    }
    
    /*
     
     double min_amount = Double.parseDouble(data.getMinBillAmt());
                                 double main_amount = Double.parseDouble(amount);
                                 double main_delivery = Double.parseDouble(delivery);
                                 double main_discount = Double.parseDouble(data.getDiscountValue());
                                 if (min_amount >= main_amount) {
                                     if (data.getDiscountType().equalsIgnoreCase("Fixed")) {
                                         discount = "" + (main_amount - main_discount);
                                         sub_total = "" + ((main_amount - main_discount) + main_delivery);
                                         txt_discount.setText("$" + discount);
                                         txt_total.setText("$" + sub_total);
                                     } else {
                                         double new_discount = ((main_amount * main_discount) / 100);
                                         discount = "" + new_discount;
                                         sub_total = "" + ((main_amount - new_discount) + main_delivery);
                                         txt_discount.setText("$" + discount);
                                         txt_total.setText("$" + sub_total);
                                     }
                                 } else {
                                     CustomSnakbar.showSnakabar(CheckoutActivity.this, v, getString(R.string.bill_must) + data.getMinBillAmt() + getString(R.string.bill_must_more));
                                 }
     
     @POST("place_an_order")
       Call<ResponseBody> place_an_order(@Query("user_id") String user_id,
                                         @Query("date") String date,
                                         @Query("address") String address,//address ID
                                         @Query("txn_id") String txn_id,
                                         @Query("txn_amount") String txn_amount,//Final amount
                                         @Query("delivery_charge") String delivery_charge,//
                                         @Query("payment_mode") String payment_mode,//online cash
                                         @Query("promocode") String promocode,//promocode ID
                                         @Query("discount") String discount,//0 :?? dicout amount
                                         @Query("vendor_id") String vendor_id,//
                                         @Query("sub_total") String sub_total,//basket total
                                         @Query("instractions") String instractions,// note
                                         @Query("wallet_amt") String wallet_amt);// 0
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CheckOutViewController{
    
    
    func call_WsPlaceOrder(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let todayDate = dateFormatter.string(from: date)
        print(dateFormatter.string(from: date))
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,
                         "date":todayDate,
                         "address":self.addressID,
                         "txn_id":"",
                         "txn_amount":self.strFinalAmount.removeFormatAmount(),
                         "delivery_charge":self.deliveryCharge.removeFormatAmount(),
                         "payment_mode":self.paymentMode,
                         "promocode":self.strPromocodeID,
                         "discount":self.strDiscountAmount.removeFormatAmount(),
                         "vendor_id":self.vendorID,
                         "sub_total":self.basketTotal.removeFormatAmount(),
                         "instractions":self.instruction,
                         "wallet_amt":"0"]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_PlaceAnOrder, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                
                if let dictData = response["result"]as? [String:Any]{
                    
                    if let orderID = dictData["order_id"]as? String{
                        self.strOrderID = orderID
                    }else  if let orderID = dictData["order_id"]as? Int{
                        self.strOrderID = "\(orderID)"
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlacedViewController")as! OrderPlacedViewController
                    vc.orderID = self.strOrderID
                    self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    func call_WsBuyOffer(strPromocode:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let dict = ["user_id": self.vendorID, "promocode":strPromocode]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPromoCode, params: dict, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                if let arrDictData = response["result"]as? [[String:Any]]{
                    
                    if arrDictData.count != 0{
                        let dictData = arrDictData[0]
                        
                        var discountType = ""
                        var main_discount:Double = 0.0
                        
                        if let type = dictData["discount_type"]as? String{
                            discountType = type
                        }
                        
                        if let discountAmount = dictData["discount_value"]as? String{
                            main_discount = Double(discountAmount) ?? 0.0
                        }else if let discountAmount = dictData["discount_value"]as? Int{
                            main_discount = Double(discountAmount)
                        }else if let discountAmount = dictData["discount_value"]as? Double{
                            main_discount = discountAmount
                        }
                        
                        if let min_bill_amt = dictData["min_bill_amt"]as? String{
                            self.min_amount = Double(min_bill_amt) ?? 0.0
                        }else if let min_bill_amt = dictData["min_bill_amt"]as? Int{
                            self.min_amount = Double(min_bill_amt)
                        }else if let min_bill_amt = dictData["min_bill_amt"]as? Double{
                            self.min_amount = min_bill_amt
                        }
                        /*
                        double min_amount = Double.parseDouble(data.getMinBillAmt());
                         double main_amount = Double.parseDouble(amount);// -> My Cart Total Amount
                         double main_delivery = Double.parseDouble(delivery); -> Delivry Charge My Cart
                         double main_discount = Double.parseDouble(data.getDiscountValue()); -> Main Discount

                                               
                         if (min_amount <= main_amount) {
                          if (data.getDiscountType().equalsIgnoreCase("Fixed")) {
                              discount = "" + (main_amount - main_discount);
                              sub_total = "" + ((main_amount - main_discount) + main_delivery);
                              txt_discount.setText("$" + main_discount);
                              txt_total.setText("$" + sub_total);
                            } else {
                               double new_discount = ((main_amount * main_discount) / 100);
                               discount = "" + new_discount;
                               sub_total = "" + ((main_amount - new_discount) + main_delivery);
                               txt_discount.setText("$" + new_discount);
                               txt_total.setText("$" + sub_total);
                            }
                            } else {
                                CustomSnakbar.showSnakabar(CheckoutActivity.this, v, getString(R.string.bill_must) + data.getMinBillAmt() + getString(R.string.bill_must_more));
                            }
 */
                        
                        var subTotal:Double = 0.0
                        let strDeliveryCharge = self.deliveryCharge.removeFormatAmount()
                        
                        print(self.min_amount)
                        print(self.main_amount)
                        if self.min_amount <= self.main_amount{
                            if discountType == "Fixed"{
                                self.lblDiscount.text = "\(self.main_amount - main_discount)"
                                subTotal = (self.main_amount - main_discount) + strDeliveryCharge
                                print(subTotal)
                                self.lblDiscount.text = "$" + "\(main_discount)"
                                self.lblFinalAmount.text = "$" + "\(subTotal)"
                            }else{
                                let newDiscount:Double = ((self.main_amount * main_discount) / 100)
                                self.lblDiscount.text = "$\(newDiscount)"
                                subTotal = (self.main_amount - newDiscount) + strDeliveryCharge
                                print(subTotal)
                                self.lblDiscount.text = "$" + "\(newDiscount)"
                                self.strDiscountAmount = "\(main_discount)"
                                self.lblFinalAmount.text = "$" + "\(subTotal)"
                            }
                        }else{
                            objAlert.showAlert(message: "Your amount is must bigger than minimum amount", title: "Alert", controller: self)
                        }
                    }
                    
                }else{
                    objAlert.showAlert(message: "Offer not found", title: "Alert", controller: self)
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




extension String {
       public func removeFormatAmount() -> Double {
           let formatter = NumberFormatter()
           formatter.locale = Locale.current
           formatter.numberStyle = .currency
           formatter.currencySymbol = Locale.current.currencySymbol
           formatter.decimalSeparator = Locale.current.groupingSeparator
           return formatter.number(from: self)?.doubleValue ?? 0.00
       }
   }


extension String {
    func changeDate(_ mydate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from: mydate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: convertedDate!)
        return date
    }
}
