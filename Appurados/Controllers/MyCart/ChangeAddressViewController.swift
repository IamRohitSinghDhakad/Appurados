//
//  ChangeAddressViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 10/09/21.
//

import UIKit

class ChangeAddressViewController: UIViewController {

    @IBOutlet weak var tblAddress: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAddNewAddress(_ sender: Any) {
        self.pushVc(viewConterlerId: "AddNewAddressViewController")
    }

    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
}
