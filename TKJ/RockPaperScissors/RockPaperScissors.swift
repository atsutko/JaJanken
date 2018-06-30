//
//  RockPaperScissors.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/18.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class RockPaperScissors: NSObject {
    
    //じゃんけん。0：グー、１：チョキ、２：パー
    var player1: Int = 0
    var player2: Int = 0
    
    //じゃんけん、対戦
    static func battle(player1: Int, player2: Int) -> Int {
        //結果を整数で返す。０：player1勝利、１：あいこ、２：player1敗北、３：エラー
        var result: Int = 0
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

}
