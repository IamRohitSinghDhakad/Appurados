//
//  FoodDetailViewController.swift
//  Appurados
//
//  Created by Rohit Singh Dhakad on 01/09/21.
//

import UIKit

class FoodDetailViewController: UIViewController {


    @IBOutlet var cvStickyHeader: UICollectionView!
    @IBOutlet var tblVwContent: UITableView!
    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet var tblHgtConstact: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvStickyHeader.delegate = self
        self.cvStickyHeader.dataSource = self
        
        self.tblVwContent.delegate = self
        self.tblVwContent.dataSource = self
        
        self.scrollVw.delegate = self

    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHgtConstact?.constant = self.tblVwContent.contentSize.height
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
}


extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodDetailCollectionViewCell", for: indexPath)as! FoodDetailCollectionViewCell
        
        return cell
    }
    
    
    
}

extension FoodDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailTableViewCell")as! FoodDetailTableViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
}

extension FoodDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var headerFrame = self.cvStickyHeader.frame
        headerFrame.origin.y = CGFloat(max(self.cvStickyHeader.frame.origin.y, scrollView.contentOffset.y))
        self.cvStickyHeader.frame = headerFrame
    }
}
