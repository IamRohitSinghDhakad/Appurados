//
//  SupportViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 29/08/21.
//

import UIKit

class SupportViewController: UIViewController {
    
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet var txtVwChat: RDTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34
    var myID = ""
    var timer: Timer?
    var arrCount = Int()
    var initilizeFirstTimeOnly = Bool()
    var arrChatMsg = [ChatDetailModel]()
    //var dictPrevious = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblChatList.delegate = self
        self.tblChatList.dataSource = self

        if self.timer == nil{
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }else{
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.call_GetChat()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func updateTimer() {
        //example functionality
        self.call_GetChat()
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtVwChat.text?.isEmpty)!{
            
            self.txtVwChat.text = "."
            self.txtVwChat.text = self.txtVwChat.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtVwChat.isScrollEnabled = false
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            self.txtVwChat.text = ""
            
            if self.txtVwChat.text!.count > 0{
                
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
            
        }else{
            
         
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            DispatchQueue.main.async {
                let text  = self.txtVwChat.text!//.encodeEmoji
                self.sendMessageNew(strText: text)
            }
            if self.txtVwChat.text!.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
    }
    
}

//MARK:- Uitablevie Delegates and DataSource
extension SupportViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        
        
        let obj = self.arrChatMsg[indexPath.row]
       
        if obj.strByAdmin == "0"{
                cell.vwMyMsg.isHidden = false
                cell.lblMyMsg.text = obj.strOpponentChatMessage
                cell.lblMyMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = true
            
            }else{
                cell.lblOpponentMsg.text = obj.strOpponentChatMessage
                cell.lblopponentMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = false
                cell.vwMyMsg.isHidden = true
            }
        
        cell.lblOpponentMsg.text = obj.strOpponentChatMessage

       
        return cell
    }
}

//MARK:- Chat Delegates and webservice calling

//MARK:- UItextViewHeightManage
extension SupportViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
          if self.txtVwChat.text == "\n"{
              self.txtVwChat.resignFirstResponder()
          }
          else{
          }
          return true
      }
      
    func textViewDidEndEditing(_ textView: UITextView) {
       
    }
      
      func textViewDidChange(_ textView: UITextView)
      {
          if self.txtVwChat.contentSize.height >= self.txtViewCommentMaxHeight
          {
              self.txtVwChat.isScrollEnabled = true
          }
          else
          {
              self.txtVwChat.frame.size.height = self.txtVwChat.contentSize.height
              self.txtVwChat.isScrollEnabled = false
          }
      }
      
    
    
    func sendMessageNew(strText:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
           // self.call_SendTextMessageOnly(strUserID: "", strText: "Hello iOS First Chat Message")
           // self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
            self.call_SendTextMessageOnly(strText: self.txtVwChat.text!)
        }
        self.txtVwChat.text = ""
    }
    
    func updateTableContentInset() {
        let numRows = self.tblChatList.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblChatList.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblChatList.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblChatList.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
}


extension SupportViewController{
    
    func call_GetChat(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
       
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
    
        objWebServiceManager.requestPost(strURL: WsUrl.url_getChatMessage, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { [self] (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                

                if let arrData  = response["result"] as? [[String:Any]] {
                    var newArrayChatMessages: [ChatDetailModel] = []
                    for dict in arrData {
                        let obj = ChatDetailModel.init(dict: dict)
                        newArrayChatMessages.append(obj)
                    }
                    
                    if self.arrChatMsg.count == 0 {
                        //Add initially all
                        self.arrChatMsg.removeAll()
                        self.tblChatList.reloadData()
                        
                        for i in 0..<arrData.count{
                            let dictdata = arrData[i]
                            let obj = ChatDetailModel.init(dict: dictdata)
                            self.arrChatMsg.insert(obj, at: i)
                            self.tblChatList.insertRows(at: [IndexPath(item: i, section: 0)], with: .none)
                        }
                        DispatchQueue.main.async {
                            self.tblChatList.scrollToBottom()
                        }
                       
                    }
                    else {
                        let previoudIds = self.arrChatMsg.map { $0.strMsgIDForDelete }
                        let newIds = newArrayChatMessages.map { $0.strMsgIDForDelete }

                        let previoudIdsSet = Set(previoudIds)
                        let newIdsSet = Set(newIds)
                        
                        let unique = (previoudIdsSet.symmetricDifference(newIdsSet)).sorted()
                        
                        for uniqueId in unique {
                            if previoudIds.contains(uniqueId) {
                                //Remove the element
                                if let idToDelete = self.arrChatMsg.firstIndex(where: { $0.strMsgIDForDelete == uniqueId }) {
                                    self.arrChatMsg.remove(at: idToDelete)
                                    self.tblChatList.deleteRows(at: [IndexPath(item: idToDelete, section: 0)], with: .none)
                                    
                                }
                            }
                            else if newIds.contains(uniqueId) {
                                // Add new element
                                let filterObj = newArrayChatMessages.filter({ $0.strMsgIDForDelete == uniqueId })
                                if filterObj.count > 0 {
                                    let index = self.arrChatMsg.count
                                    self.arrChatMsg.insert(filterObj[0], at: index)
                                    self.tblChatList.insertRows(at: [IndexPath(item: index, section: 0)], with: .none)
                                    self.tblChatList.scrollToBottom()
                                }
                            }
                        }
                    }
                    
                    if self.initilizeFirstTimeOnly == false{
                        self.initilizeFirstTimeOnly = true
                        self.arrCount = self.arrChatMsg.count
                    }
                
                    if self.arrCount == self.arrChatMsg.count{
                        
                    }else{
                        self.updateTableContentInset()
                    }
                    
                    
                    if self.arrChatMsg.count == 0{
                        self.tblChatList.displayBackgroundText(text: "No Message Found!")
                    }else{
                        self.tblChatList.displayBackgroundText(text: "")
                    }
                    

                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Send Text message Only
    
    func call_SendTextMessageOnly(strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        

        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId,//My ID
                        // "type":"text",
                         "message":strText]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_sendMessage, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if let result = response["result"]as? String{
                if result == "successful"{
                   // self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
                }
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
}


class ChatListCell:UITableViewCell {
    
    @IBOutlet weak var vwOpponent: UIView!
    @IBOutlet weak var vwMyMsg: UIView!
    @IBOutlet weak var lblOpponentMsg: UILabel!
    @IBOutlet weak var lblopponentMsgTime: UILabel!
    @IBOutlet weak var lblMyMsg: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    
    @IBOutlet var imgVwMine: UIImageView!
    @IBOutlet var imgVwOpponent: UIImageView!
    override func awakeFromNib() {
        
    }
    
}


//MARK:- Scroll to bottom
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
