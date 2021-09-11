//
//  AddNewAddressViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 10/09/21.
//

import UIKit

class AddNewAddressViewController: UIViewController {

    var strAddressType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddressTypeSelect(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.strAddressType = "Home"
        case 1:
            self.strAddressType = "Office"
        default:
            self.strAddressType = "Other"
        }
    }
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    

}
