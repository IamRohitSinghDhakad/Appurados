//
//  SendPackageFormFillViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 13/09/21.
//

import UIKit

class SendPackageFormFillViewController: UIViewController {

    @IBOutlet var tfFullName: UITextField!
    @IBOutlet var tfPhoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnSend(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
