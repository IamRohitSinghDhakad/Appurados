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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPackageDropOffViewController")as! SendPackageDropOffViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   

}
