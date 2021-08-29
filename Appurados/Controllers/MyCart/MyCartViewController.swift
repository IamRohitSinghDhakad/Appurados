//
//  MyCartViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class MyCartViewController: UIViewController {

    @IBOutlet var tblHgtConstant: NSLayoutConstraint!
    @IBOutlet var tblOrders: UITableView!
    @IBOutlet var lblBasketTotal: UILabel!
    @IBOutlet var lblDeliveryCharges: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblDeliverTo: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var subVwConfirmation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblOrders.delegate = self
        self.tblOrders.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    /// Manage Table vuew hight :----->
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHgtConstant?.constant = self.tblOrders.contentSize.height
    }
    
    @IBAction func btnOnChangeAddress(_ sender: Any) {
        
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.subVwConfirmation.isHidden = false
    }
    @IBAction func btnOnCheckUncheckSpclReq(_ sender: Any) {
        
    }
    
    @IBAction func btnOnAddItems(_ sender: Any) {
        
    }
    
    @IBAction func btnOnCheckout(_ sender: Any) {
        
    }
    
    
    @IBAction func btnCancelSubVw(_ sender: Any) {
        self.subVwConfirmation.isHidden = true
    }
    
    @IBAction func btnYesSubVw(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

/// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension MyCartViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableViewCell")as! MyCartTableViewCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
}
