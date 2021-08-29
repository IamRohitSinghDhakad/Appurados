//
//  MyOrdersViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 28/08/21.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    var currentPage = 0
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet var lblPendingActive: UILabel!
    @IBOutlet var lblOngoingActive: UILabel!
    @IBOutlet var lblCompleteActive: UILabel!
    @IBOutlet var lblPendingText: UILabel!
    @IBOutlet var lblOngoingText: UILabel!
    @IBOutlet var lblCompleteText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.setupScrollView()
            self.findPageNumber()
        }
       
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnPending(_ sender: Any) {
        self.displayDataForPendingTab()
    }
    
    @IBAction func btnOnOngoing(_ sender: Any) {
        self.displayDataForOngoingTab()
    }
    
    @IBAction func btnOnComplete(_ sender: Any) {
        self.displayDataForCompleteTab()
    }
}


//MARK:- extension for custom method
extension MyOrdersViewController: UIScrollViewDelegate{
    
    func loadInitialData(){
        self.scrollView.delegate = self
        self.initChildControllers()
        self.setInactiveToAll()
        self.displayDataForPendingTab()
        
        
        
//        self.vwHeader.clipsToBounds = true
//        self.vwHeader.layer.cornerRadius = 45
//        self.vwHeader.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        
//        self.vwHeader.layer.shadowPath =
//              UIBezierPath(roundedRect: self.vwHeader.bounds,
//              cornerRadius: self.vwHeader.layer.cornerRadius).cgPath
//        self.vwHeader.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
//        self.vwHeader.layer.shadowOpacity = 1
//        self.vwHeader.layer.shadowOffset = CGSize(width: 0, height: 4)
//        self.vwHeader.layer.shadowRadius = 4
//        self.vwHeader.layer.masksToBounds = false
        
        
    }

    func setInactiveToAll(){
        self.lblPendingActive.backgroundColor = .clear
        self.lblOngoingActive.backgroundColor = .clear
        self.lblCompleteActive.backgroundColor = .clear
        
        self.lblPendingText.textColor = .black
        self.lblOngoingText.textColor = .black
        self.lblCompleteText.textColor = .black
    }
    

    func displayDataForPendingTab(){
        self.move(toPage: 0)
        self.setInactiveToAll()
        
        self.lblPendingText.textColor = UIColor.init(named: "AppColor")
        self.lblPendingActive.backgroundColor = UIColor.init(named: "AppColor")
      
    }

    func displayDataForOngoingTab(){
        self.move(toPage: 1)
        self.setInactiveToAll()
        
        self.lblOngoingText.textColor = UIColor.init(named: "AppColor")
        self.lblOngoingActive.backgroundColor = UIColor.init(named: "AppColor")

    }
    
    func displayDataForCompleteTab(){
        self.move(toPage: 2)
        self.setInactiveToAll()
        
        self.lblCompleteText.textColor = UIColor.init(named: "AppColor")
        self.lblCompleteActive.backgroundColor = UIColor.init(named: "AppColor")
    }
}


//MARK:- extension for paging management
extension MyOrdersViewController{
    func initChildControllers()  {

        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)

        let objPendingVC = sb.instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
        let objOnGoingVC  = sb.instantiateViewController(withIdentifier: "OngoingViewController") as! OngoingViewController
        let objCompleteVC  = sb.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController

        self.addChild(objPendingVC)
        self.addChild(objOnGoingVC)
        self.addChild(objCompleteVC)

        self.scrollView.addSubview(objPendingVC.view)
        self.scrollView.addSubview(objOnGoingVC.view)
        self.scrollView.addSubview(objCompleteVC.view)
        self.scrollView.delegate =  self
        objPendingVC.didMove(toParent: self)
        objOnGoingVC.didMove(toParent: self)
        objCompleteVC.didMove(toParent: self)
    }

    func setupScrollView()  {
        self.currentPage = 0
        for (index, _) in self.children.enumerated() {
            self.loadScrollView(withPage: index)
        }
        let w = self.view.frame.width * CGFloat(self.children.count)
        self.scrollView.contentSize = CGSize(width: w, height: self.scrollView.frame.height)
    }

    func loadScrollView(withPage page: Int) {
        if page < 0 {return}
        if page >= children.count {return}
        // replace the placeholder if necessary
        let controller: UIViewController = children[page]
        var frame: CGRect = view.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        frame.size.height = self.scrollView.frame.height
        controller.view.frame = frame
        self.scrollView.addSubview(controller.view)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.findPageNumber()
    }

    func findPageNumber() {
        let pageWidth = scrollView.frame.size.width
        var xOffset: CGFloat = 0.0

        xOffset = scrollView.contentOffset.x

        let w: CGFloat = xOffset - pageWidth / 2
        let page = Int(floor(w / pageWidth) + 1)

        if self.currentPage != page {

            let oldViewController: UIViewController = children[self.currentPage]
            let newViewController: UIViewController = children[page]
            oldViewController.viewWillDisappear(true)
            newViewController.viewWillAppear(true)
            self.currentPage = page

            //segmentControl.selectedSegmentIndex = page
            //print("Page changed: \(page)")
            oldViewController.viewDidDisappear(true)
            newViewController.viewDidAppear(true)
        }

        if page == 0{
            self.setInactiveToAll()
            self.displayDataForPendingTab()
        }else if page == 1{
            self.setInactiveToAll()
            self.displayDataForOngoingTab()
        }else{
            self.setInactiveToAll()
            self.displayDataForCompleteTab()
        }
    }

    func move(toPage page: Int) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        let oldViewController: UIViewController = children[self.currentPage]
        let newViewController: UIViewController = children[page]
        oldViewController.viewWillDisappear(true)
        newViewController.viewWillAppear(true)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}
