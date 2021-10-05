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
    
    var dictPackageData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnSend(_ sender: Any) {
        
        if self.tfFullName.text!.isEmpty{
            objAlert.showAlert(message: "Please enter name", title: "Alert", controller: self)
        }else if self.tfPhoneNumber.text!.isEmpty{
            objAlert.showAlert(message: "Please enter Number", title: "Alert", controller: self)
        }else{
            
            self.dictPackageData["Name"] = self.tfFullName.text
            self.dictPackageData["Phone"] = self.tfPhoneNumber.text
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPackageDropOffViewController")as! SendPackageDropOffViewController
            vc.dictPackageData = self.dictPackageData
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
      
    }
    
   

}
