//
//  MyRewardViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class MyRewardViewController: UIViewController {

    @IBOutlet var tblRewardList: UITableView!
    @IBOutlet var lblTotalPoints: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRewardList.delegate = self
        self.tblRewardList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnRedeemNow(_ sender: Any) {
        
    }
}


extension MyRewardViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRewardTableViewCell")as! MyRewardTableViewCell
        
        
        return cell
    }
    
    
    
    
}
