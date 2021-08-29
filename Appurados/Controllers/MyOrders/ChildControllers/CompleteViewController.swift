//
//  CompleteViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class CompleteViewController: UIViewController {

    @IBOutlet var tblCompleteOrderList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblCompleteOrderList.delegate = self
        self.tblCompleteOrderList.dataSource = self

        // Do any additional setup after loading the view.
    }
    

   

}


//UITableView Delegates and DataSource
extension CompleteViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingOrderListTableViewCell")as! PendingOrderListTableViewCell
        
        return cell
    }
}

