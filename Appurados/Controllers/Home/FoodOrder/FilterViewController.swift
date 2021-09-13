//
//  FilterViewController.swift
//  Appurados
//
//  Created by Rohit Singh on 13/09/21.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblFilter: UITableView!
    
    
    var strTitle:String?
    var isFromFilter:Bool?
    
    var closerForDictFilter: (( _ strDict:[String:Any]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = strTitle
        // Do any additional setup after loading the view.
        
        self.tblFilter.delegate = self
        self.tblFilter.dataSource = self
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Send Data Back")
        }
    }
    @IBAction func btnOnApply(_ sender: Any) {
        
        var dict = [String:Any]()
        dict["update_subcat"] = "Values Insert needed"
        
        self.closerForDictFilter?(dict)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
}



extension FilterViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell")as! FilterTableViewCell
        
        
        return cell
    }
    
    
    
    
}
