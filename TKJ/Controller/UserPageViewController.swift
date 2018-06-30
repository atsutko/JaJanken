//
//  UserPageViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Firebase
import NYXImagesKit
import Kingfisher
import SCLAlertView

class UserPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var percentArray: [WinPercent] = []
    
    @IBOutlet weak var profBackImageView: UIImageView!
    @IBOutlet weak var winPercentTableView: UITableView!
    @IBOutlet weak var userProfImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIntroTextView: UITextView!
    @IBOutlet weak var profChangeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //変更ボタンのレイアウト調整
        self.profChangeButton.layer.cornerRadius = self.profChangeButton.layer.bounds.width/2
        self.profChangeButton.layer.masksToBounds = true

        //プロフィール画像の角を丸くする
        self.userProfImageView.layer.cornerRadius = self.userProfImageView.bounds.height/2
        self.userProfImageView.layer.masksToBounds = true
        
        loadMyProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return percentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinPercentCell") as! WinPercentTableViewCell
        return cell
    }
    
    func loadMyProfile() {
        if let user = Auth.auth().currentUser {
            self.userNameLabel.text = user.displayName
            
           
        } else {
            //ログインされてない。
            //ユーザーがログインしていない状態
            let alertView: SCLAlertView = SCLAlertView()
            alertView.addButton("OK", target: self, selector: #selector(EditUserViewController.OKButtonPushed))
            alertView.showError("ユーザーログイン", subTitle: "ログインしなおしてください")

        }
    }
    
    @objc func OKButtonPushed() {
        // userのアクティブ状態を変更できたらログイン画面に移動
        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
        // ログイン状態の保持
        let ud = UserDefaults.standard
        ud.set(false, forKey: "isLogin")
        ud.synchronize()
    }
    
    @IBAction func changeButtonPushed() {
        self.performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }


}
