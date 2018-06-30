//
//  AMHViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/18.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Koloda
import Pop

//あっち向いてホイ

class AMHViewController: UIViewController, UIGestureRecognizerDelegate {
   
    //phase2の選択に関する定義
    private var numberOfCards: Int = 1
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        
        return array
    }()
    
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
    
    var AMHImageView = UIImageView()
    
    var phase1Result: Int = 0
    var player1WinCount: Int = 0
    var player2WinCount: Int = 0
    
    var timer: Timer?
    var index: Int = 0
    var GCPImageArray: [UIImage] = [UIImage(named: "グー.png")!, UIImage(named: "チョキ.png")!, UIImage(named: "パー.png")!]
    
    
    var tapEndPosX:CGFloat = 0
    var tapEndPosY:CGFloat = 0
    
    var selectAMHDirection: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
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
            self.phase1Result = 0
            self.setUpAMHView()
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
            self.phase1Result = 2
            self.setUpAMHView()
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
           
                }
            }
        default:
            break
        }
    }
    
    func phase2ResultReport(result: Int) {
        switch result {
        case 0:
            //勝った場合
            self.player1WinCount = player1WinCount + 1
            self.player1WinCountLabel.text = String(self.player1WinCount)
            if self.player1WinCount == 3 {
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
        case 1:
            //もう一度、phase1に戻る
            AMHImageView.isHidden = true
        case 2:
            //負けた場合
            self.player2WinCount = player2WinCount + 1
            self.player2WinCountLabel.text = String(self.player2WinCount)
            if self.player2WinCount == 3 {
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

        default:
            break
        }
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
    
    func setUpAMHView() {
        let AMHView = KolodaView()
        AMHView.frame = CGRect(x: 0, y: 0, width: 150.0, height: 150.0)
        AMHView.center = self.view.center
        self.view.addSubview(AMHView)
        AMHView.delegate = self
        AMHView.dataSource = self
        
    }
    
    //パンジェスチャーのセット
    func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self.AMHImageView, action: #selector(AMHViewController.panView(sender:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panView(sender: UIPanGestureRecognizer) {
        // 指が離れた時（sender.state = .ended）だけ処理をする
        switch sender.state {
        case .ended:
            // タップ開始地点からの移動量を取得
            let position = sender.translation(in: view)
            tapEndPosX = position.x     // x方向の移動量
            tapEndPosY = -position.y    // y方向の移動量（上をプラスと扱うため、符号反転する）
            // 上下左右のフリック方向を判別する
            // xがプラスの場合（右方向）とマイナスの場合（左方向）で場合分け
            if tapEndPosX > 0 {
                // 右方向へのフリック
                if tapEndPosY > tapEndPosX {
                    // yの移動量がxより大きい→上方向
                    self.selectAMHDirection = 0
                    self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
    
                } else if tapEndPosY < -tapEndPosX {
                    // yの移動量が-xより小さい→下方向
                    self.selectAMHDirection = 2
                     self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
                } else {
                    // 右方向
                    self.selectAMHDirection = 3
                      self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
                }
            } else {
                // 左方向へのフリック
                if tapEndPosY > -tapEndPosX {
                    // yの移動量が-xより大きい→上方向
                    self.selectAMHDirection = 0
                      self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
                } else if tapEndPosY < tapEndPosX {
                    // yの移動量がxより小さい→下方向
                    self.selectAMHDirection = 2
                self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
                } else {
                    // 左方向
                    self.selectAMHDirection = 1
                      self.phase2ResultReport(result: AMH.phase2Computer(phase1Result: phase1Result, player1: selectAMHDirection))
                }
            }
        default:
            break
        }
    }

}

extension AMHViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let position = kolodaView.currentCardIndex
        for i in 1...4 {
            dataSource.append(UIImage(named: "Card_like_\(i)")!)
        }
        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
}

// MARK: KolodaViewDataSource

extension AMHViewController: KolodaViewDataSource {
    
    
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
