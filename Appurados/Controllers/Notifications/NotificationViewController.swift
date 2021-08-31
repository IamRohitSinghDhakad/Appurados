//
//  NotificationViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tblNotifications: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblNotifications.delegate = self
        self.tblNotifications.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
   
}


extension NotificationViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        
        
        return cell
    }
    
    
    
    
}
