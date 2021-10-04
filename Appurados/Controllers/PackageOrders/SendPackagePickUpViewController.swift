//
//  SendPackagePickUpViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 03/10/21.
//

import UIKit

class SendPackagePickUpViewController: UIViewController {

    @IBOutlet weak var lblLandmark: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapVw: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOpenPlacePicker(_ sender: Any) {
    }
    
    @IBAction func btnNext(_ sender: Any) {
        
    }
    
}
