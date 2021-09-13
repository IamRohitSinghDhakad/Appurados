//
//  DishDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 27/08/21.
//

import UIKit

class DishDetailViewController: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblRestaurents: UITableView!
    @IBOutlet var tfSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRestaurents.delegate = self
        self.tblRestaurents.dataSource = self
        
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
}


// ============================== ##### UITableView Delegates And Datasources ##### ==================================//

extension DishDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOrderTableViewCell")as! FoodOrderTableViewCell
        
        return cell
    }
    
}


