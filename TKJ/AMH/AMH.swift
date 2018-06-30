//
//  AMH.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/18.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class AMH: NSObject {

    //じゃんけん。0：グー、１：チョキ、２：パー
    var player1: Int = 0
    var player2: Int = 0
    
    //じゃんけん、コンピューター
    static func phase1Computer(player1: Int) -> Int {
        let computer: Int = Int(arc4random_uniform(3))
        //結果を整数で返す。０：player1勝利、１：あいこ、２：player1敗北、３：エラー
        var result: Int = 3
        switch computer {
        case 0:
            switch player1 {
            case 0:
                result = 1
                return result
            case 1:
                result = 2
                return result
            case 2:
                result = 0
                return result
            default:
                break
            }
        case 1:
            switch player1 {
            case 0:
                result = 0
                return result
            case 1:
                result = 1
                return result
            case 2:
                result = 2
                return result
            default:
                break
            }
        case 2:
            switch player1 {
            case 0:
                result = 2
                return result
            case 1:
                result = 0
                return result
            case 2:
                result = 1
                return result
            default:
                break
            }
        default:
            break
        }
        
        return result
        
    }
    
    //じゃんけん、対戦
    static func phase1Battle(player1: Int, player2: Int) -> Int {
        //結果を整数で返す。０：player1勝利、１：あいこ、２：player1敗北、３：エラー
        var result: Int = 3
        switch player2 {
        case 0:
            switch player1 {
            case 0:
                result = 1
                return result
            case 1:
                result = 2
                return result
            case 2:
                result = 0
                return result
            default:
                break
            }
        case 1:
            switch player1 {
            case 0:
                result = 0
                return result
            case 1:
                result = 1
                return result
            case 2:
                result = 2
                return result
            default:
                break
            }
        case 2:
            switch player1 {
            case 0:
                result = 2
                return result
            case 1:
                result = 0
                return result
            case 2:
                result = 1
                return result
            default:
                break
            }
        default:
            break
        }
        
        return result
        
    }
    
    //あっち向いてホイ。コンピューター。
    static func phase2Computer(phase1Result: Int, player1: Int) -> Int {
        //０：上、１：左、２：下、３：右
        let computer: Int = Int(arc4random_uniform(4))
        //結果を整数で返す。０：player1勝利、1：Phase1に戻る、2：player1敗北,３：エラー
        var result: Int = 3
        if computer == player1 {
            if phase1Result == 2 {
                result = 2
                return result
            } else {
                result = 0
                return result
            }
        } else {
            result = 1
            return result
        }

    }
    
    //あっち向いてホイ。対戦
    static func phase2Battle(player1: Int, player2: Int, phase1Result: Int) -> Int {
        //０：上、１：左、２：下、３：右
        //結果を整数で返す。０：player1勝利、1：player1敗北、2：Phase1に戻る、３：エラー
        var result: Int = 3
        
        //phase1でplayer1が勝っていた場合
        if phase1Result == 0 {
            if player1 == player2 {
                result = 0
                return result
            } else {
                result = 2
                return result
            }
        } else {
            //phase1でplayer1が負けていた場合
            if player1 == player2 {
                result = 1
                return result
            } else {
                result = 2
                return result
            }
        }
    }
   

}
