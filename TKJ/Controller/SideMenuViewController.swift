//
//  SideMenuViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/27.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import SideMenu
import SCLAlertView

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    var sideMenuTextArray: [String] = ["ログアウト","退会"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuTableView.reloadData()
        
        guard SideMenuManager.default.menuBlurEffectStyle == nil else {
            return
        }
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        
        sideMenuTableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuTextArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewVibrantCell
        
        cell.blurEffectStyle = SideMenuManager.default.menuBlurEffectStyle
        cell.textLabel?.text = sideMenuTextArray[indexPath.row]
        
        return cell

    }
    
    func 
    
    

    
}
