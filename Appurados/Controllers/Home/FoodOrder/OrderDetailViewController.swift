//
//  OrderDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 31/08/21.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var imgVwDish: UIImageView!
    @IBOutlet weak var tblVarientHgtConstant: NSLayoutConstraint!
    @IBOutlet weak var tblvarient: UITableView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblvarient.delegate = self
        self.tblvarient.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblVarientHgtConstant?.constant = self.tblvarient.contentSize.height
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        
    }
    @IBAction func btnPlus(_ sender: Any) {
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    

}


extension OrderDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VarientTableViewCell")as! VarientTableViewCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
}
