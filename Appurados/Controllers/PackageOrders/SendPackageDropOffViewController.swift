//
//  SendPackageDropOffViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 03/10/21.
//

import UIKit

class SendPackageDropOffViewController: UIViewController {
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tfLandMark: UITextField!
    @IBOutlet weak var mapVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnOnNext(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPackagePickUpViewController")as! SendPackagePickUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOpenaddressPicker(_ sender: Any) {
        
    }
    
}
