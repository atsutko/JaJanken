//
//  CategoryViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import NYXImagesKit
import Kingfisher
import SideMenu

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var categoryArray = [Category]()
    

    @IBOutlet weak var categoryTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        let nib = UINib(nibName: "CategoryTableViewCell", bundle: Bundle.main)
        categoryTableView.register(nib, forCellReuseIdentifier: "CategoryCell")
        
        categoryTableView.tableFooterView = UIView()
        
        categoryTableView.rowHeight = 170.0
        
        setUpCategory()
        
        setUpSideMenu()


    }
    
    /*
    override var prefersStatusBarHidden: Bool {
        return true
    }
 */
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }
    
    @IBAction func sideMenuAppear() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func setUpCategory() {
        let category1 = Category(title: "ジャンケン！", image: UIImage(named: "tataitekabuttejankenpong.png")!)
        let category2 = Category(title: "あっち向いてホイ！", image: UIImage(named: "tataitekabuttejankenpong.png")!)
        let category3 = Category(title: "叩いてかぶってジャンケンポン", image: UIImage(named: "tataitekabuttejankenpong.png")!)

        categoryArray.append(category1)
        categoryArray.append(category2)
        categoryArray.append(category3)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryTableViewCell
        cell.categoryLabel.text = categoryArray[indexPath.row].title
        cell.backgroundImageView.image = categoryArray[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "toJanken", sender: nil)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "toAMH", sender: nil)
        }
    }
    

}
