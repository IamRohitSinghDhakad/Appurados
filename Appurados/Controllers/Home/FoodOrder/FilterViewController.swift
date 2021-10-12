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
    var arrFilterOption = [FilterModel]()
    var arrSubCategory = [OfferCategoryModel]()
    
    var closerForDictFilter: (( _ strDict:[String:Any]) ->())?
    var closerForDictOfferCategory: (( _ strDict:[String:Any]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = strTitle
        // Do any additional setup after loading the view.
        
        if isFromFilter!{
            self.arrFilterOption = [FilterModel(filterString: "RESTAURANTS WITHOUT MINIMUM ORDER", isSelectedFilter: false), FilterModel(filterString: "NEW RESTAURANTS", isSelectedFilter: false), FilterModel(filterString: "RECOMMENDED RESTAURANTS", isSelectedFilter: false), FilterModel(filterString: "BEST RATED RESTAURANTS", isSelectedFilter: false), FilterModel(filterString: "RESTAURANT FAVORITES", isSelectedFilter: false), FilterModel(filterString: "FREE DELIVERY", isSelectedFilter: false)]
        }else{
           // self.call_WsGetSubCategory()
        }
        
        self.tblFilter.delegate = self
        self.tblFilter.dataSource = self
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func btnOnApply(_ sender: Any) {
        
        if isFromFilter!{
            let filterdValue = self.arrFilterOption.filter({$0.strIsSelected == true})
            if filterdValue.count == 0{
                objAlert.showAlert(message: "Please select option first", title: "Alert", controller: self)
            }else{
                var arrFilterd = [String]()
                for data in filterdValue{
                    arrFilterd.append(data.strFilterData)
                }
                let values = arrFilterd.joined(separator: ",")
                var dictFilterSelectedOption = [String:Any]()
                dictFilterSelectedOption["selectedValues"] = values
                self.closerForDictFilter?(dictFilterSelectedOption)
                self.dismiss(animated: true, completion: nil)
            }
            
         
        }else{
            let filterdValue = self.arrSubCategory.filter({$0.isSelected == true})
            if filterdValue.count == 0{
                
                objAlert.showAlert(message: "Please select option first", title: "Alert", controller: self)
                
            }else{
                var arrFilterd = [String]()
                for data in filterdValue{
                    arrFilterd.append(data.strOffer_category_id)
                }
                let values = arrFilterd.joined(separator: ",")
                var dictOfferCategorySelected = [String:Any]()
                dictOfferCategorySelected["selectedID"] = values
                self.closerForDictOfferCategory?(dictOfferCategorySelected)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
      
        
    }
    
    @IBAction func btnOnClear(_ sender: Any) {
        if isFromFilter!{
            self.arrFilterOption.forEach() { $0.strIsSelected = false}
        }else{
            self.arrSubCategory.forEach() { $0.isSelected = false}
        }
      self.tblFilter.reloadData()
    }
    
}



extension FilterViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromFilter!{
            return self.arrFilterOption.count
        }else{
            return self.arrSubCategory.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell")as! FilterTableViewCell
        
        if isFromFilter!{
            cell.lblTitle.text = self.arrFilterOption[indexPath.row].strFilterData
            
            if self.arrFilterOption[indexPath.row].strIsSelected{
                cell.imgVwCheckUnCheck.image = #imageLiteral(resourceName: "select")
            }else{
                cell.imgVwCheckUnCheck.image = #imageLiteral(resourceName: "box")
            }
            
        }else{
            cell.lblTitle.text = self.arrSubCategory[indexPath.row].strOffer_category_name
            
            if self.arrSubCategory[indexPath.row].isSelected{
                cell.imgVwCheckUnCheck.image = #imageLiteral(resourceName: "select")
            }else{
                cell.imgVwCheckUnCheck.image = #imageLiteral(resourceName: "box")
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromFilter!{
            
            let obj = self.arrFilterOption[indexPath.row]
            
            if obj.strIsSelected{
                obj.strIsSelected = false
            }else{
                obj.strIsSelected = true
            }
            
        }else{
            
            let obj = self.arrSubCategory[indexPath.row]
            
            if obj.isSelected{
                obj.isSelected = false
            }else{
                obj.isSelected = true
            }
        }
        
        self.tblFilter.reloadData()
        
    }
}
