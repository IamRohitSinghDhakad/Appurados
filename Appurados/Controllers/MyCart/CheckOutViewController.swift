//
//  CheckOutViewController.swift
//  Appurados
//
//  Created by Rohit Dhakad on 08/10/21.
//

import UIKit

class CheckOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tfCoupon(_ sender: Any) {
    }
    @IBAction func btnApplyCoupon(_ sender: Any) {
        
    }
    
    /*
     
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
