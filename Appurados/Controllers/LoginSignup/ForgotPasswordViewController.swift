//
//  ForgotPasswordViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 02/09/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnOnSubmit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
