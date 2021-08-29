//
//  SendPackageViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class SendPackageViewController: UIViewController {

    @IBOutlet var tblSendPackageList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSendPackageList.delegate = self
        self.tblSendPackageList.dataSource = self
        
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

extension SendPackageViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendPackageTableViewCell")as! SendPackageTableViewCell
        
        
        return cell
        
    }
    
    
    
    
}
