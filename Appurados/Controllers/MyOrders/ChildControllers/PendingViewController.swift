//
//  PendingViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class PendingViewController: UIViewController {

    @IBOutlet var tblOrdersList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblOrdersList.delegate = self
        self.tblOrdersList.dataSource = self
        // Do any additional setup after loading the view.
    }
    

}


//UITableView Delegates and DataSource
extension PendingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingOrderListTableViewCell")as! PendingOrderListTableViewCell
        
        return cell
    }
}
