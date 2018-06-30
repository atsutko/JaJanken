//
//  JankenViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/18.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import SocketIO
import FirebaseAuth
import FirebaseDatabase
import Firebase

//じゃんけんゲーム
class JankenViewController: UIViewController {
    
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2ProfImageView: UIImageView!
    @IBOutlet weak var player2GCPImageView: UIImageView!
    @IBOutlet weak var resultReportLabel: UILabel!
    
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    
    //自分と相手の勝った数をカウント。3で勝利
    @IBOutlet weak var player1WinCountLabel: UILabel!
    @IBOutlet weak var player2WinCountLabel: UILabel!
    var player1WinCount: Int = 0
    var player2WinCount: Int = 0
    
    var timer: Timer?
    var index: Int = 0
    var GCPImageArray: [UIImage] = [UIImage(named: "グー.png")!, UIImage(named: "チョキ.png")!, UIImage(named: "パー.png")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        battleStartAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func battleStartAnimation() {
        player2ProfImageView.alpha = 0.0
        UIView.animate(withDuration: 2.0, animations: {
            self.player2NameLabel.text = "対戦スタート"
            self.player2NameLabel.alpha = 1.0
        }) { (isFinished) in
            if isFinished == true {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                self.timer?.fire()
            }
        }
    }
    
    @objc func updateGCPImageView(timer: Timer) {
        player2GCPImageView.image = GCPImageArray[index]
        
        index += 1
        if index >= GCPImageArray.count {
            index = 0
        }
    }
    
    func playerGCH(player: Int) -> UIImage {
        timer?.invalidate()
        switch player {
        case 0:
            return UIImage(named: "グー.png")!
        case 1:
            return UIImage(named: "チョキ.png")!
        case 2:
            return UIImage(named: "パー.png")!
        default:
            return UIImage(named: "パー.png")!
        }
    }
    
    func resultReport(result: Int, player: Int) {
        switch result {
        case 0:
            self.resultReportLabel.alpha = 1.0
            self.resultReportLabel.text = "あなたの勝ち！"
            self.player1WinCount = player1WinCount + 1
            self.player1WinCountLabel.text = String(self.player1WinCount)
            UIView.animate(withDuration: 1.0, animations: {
                self.resultReportLabel.alpha = 0.0
            }) { (isFinished) in
                if isFinished == true {
                    switch player {
                    case 0:
                        self.rockButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 1:
                        self.scissorsButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 2:
                        self.paperButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    default:
                        break
                    }
                    if self.player1WinCount == 3 {
                        self.saveResults()

                        let alertController = UIAlertController(title: "あなたの勝ちです！",message: "もう一度やりますか？", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                            

                            //勝利数をリセット
                            self.player1WinCount = 0
                            self.player2WinCount = 0
                            self.player1WinCountLabel.text = String(self.player1WinCount)
                            self.player2WinCountLabel.text = String(self.player2WinCount)
                            
                            //タイマーをリセット
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                            self.timer?.fire()
                        }
                        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
                        
                        alertController.addAction(okAction)
                        alertController.addAction(cancelButton)
                        
                        self.present(alertController,animated: true,completion: nil)
                    } else {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                        self.timer?.fire()
                    }
                    
                
                    
                }
            }
        case 1:
            self.resultReportLabel.alpha = 1.0
            self.resultReportLabel.text = "あいこ"
            UIView.animate(withDuration: 0.5, animations: {
                self.resultReportLabel.alpha = 0.0
            }) { (isFinished) in
                if isFinished == true {
                    switch player {
                    case 0:
                        self.rockButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 1:
                        self.scissorsButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 2:
                        self.paperButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    default:
                        break
                    }
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                    self.timer?.fire()
                }
            }
            
        case 2:
            self.resultReportLabel.alpha = 1.0
            self.resultReportLabel.text = "あなたの負け！"
            self.player2WinCount = player2WinCount + 1
            self.player2WinCountLabel.text = String(self.player2WinCount)
            UIView.animate(withDuration: 1.0, animations: {
                self.resultReportLabel.alpha = 0.0
            }) { (isFinished) in
                if isFinished == true {
                    switch player {
                    case 0:
                        self.rockButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 1:
                        self.scissorsButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    case 2:
                        self.paperButton.setBackgroundImage(self.playerGCH(player: player), for: .normal)
                    default:
                        break
                    }
                    
                    if self.player2WinCount == 3 {
                        self.saveResults()

                        let alertController = UIAlertController(title: "あなたの負けです！",message: "もう一度やりますか？", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                            

                            //勝利数をリセット
                            self.player1WinCount = 0
                            self.player2WinCount = 0
                            self.player1WinCountLabel.text = String(self.player1WinCount)
                            self.player2WinCountLabel.text = String(self.player2WinCount)
                            
                            //タイマーをリセット
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                            self.timer?.fire()
                            
                        }
                        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
                        
                        alertController.addAction(okAction)
                        alertController.addAction(cancelButton)
                        
                        self.present(alertController,animated: true,completion: nil)
                    } else {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGCPImageView(timer:)), userInfo: nil, repeats: true)
                        self.timer?.fire()
                    }
                  
                }
            }
        default:
            break
        }
    }
    
    func saveResults() {
        var reference: DatabaseReference!
        reference = Database.database().reference()
        let currentUserId = Auth.auth().currentUser?.uid
        reference.child("results").childByAutoId().setValue(["user": currentUserId, "win": self.player1WinCount, "lose": self.player2WinCount, "createDate": ServerValue.timestamp()])
    }
    
    @IBAction func rockButtonPushed(_ sender: UIButton) {
        self.rockButton.setBackgroundImage(UIImage(named: "グー（選択済）.png"), for: .normal)
        let computer = Int(arc4random_uniform(3))
        let result = RockPaperScissors.battle(player1: 0, player2: computer)
        self.player2GCPImageView.image = playerGCH(player: computer)
        self.resultReport(result: result, player: 0)
        
    }
    
    
    @IBAction func scissorsButtonPushed(_ sender: UIButton) {
        self.scissorsButton.setBackgroundImage(UIImage(named: "チョキ（選択済）.png"), for: .normal)
        let computer = Int(arc4random_uniform(3))
        let result = RockPaperScissors.battle(player1: 1, player2: computer)
        self.player2GCPImageView.image = playerGCH(player: computer)
        self.resultReport(result: result, player: 1)
    }
    
    @IBAction func paperButtonPushed(_ sender: UIButton) {
        self.paperButton.setBackgroundImage(UIImage(named: "パー（選択済）.png"), for: .normal)
        let computer = Int(arc4random_uniform(3))
        let result = RockPaperScissors.battle(player1: 2, player2: computer)
        self.player2GCPImageView.image = playerGCH(player: computer)
        self.resultReport(result: result, player: 2)
        

    }
    
    
}
