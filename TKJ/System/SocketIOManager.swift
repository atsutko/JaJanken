//
//  SocketIOManager.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/18.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {

    class var sharedInstance: SocketIOManager {
        struct Static {
            static let instance: SocketIOManager = SocketIOManager()
        }
        return Static.instance
    }
    
    private override init() {super.init()}
    
    let socket = SocketManager(socketURL: URL(string: "http://localhost:8080")!).defaultSocket
   
    func establishConnection() {
        socket.on(clientEvent: SocketClientEvent.connect) { (data, ack) in
            print(data)
        }
        socket.connect()
    }
    
    func closeConnect() {
        socket.on(clientEvent: SocketClientEvent.disconnect) { (data, ack) in
            print(data)
        }
        socket.disconnect()
    }
    
    //じゃんけん結果を送信
    func sendResult(player: Int) {
        socket.emit("from_player", player)
    }
    
    //じゃんけん結果を受信
    func getResult() {
        socket.on("from_server") { (data, ack) in
            print(data)
        }
    }
    
    
    
    /*
    // メッセージ送信.
    func sendMessage(_ message: String, name: String) {
        socket.emit("from_client", name, message)
    }
    
    // メッセージ受信.
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: JSQMessage) -> Void) {
        socket.on("from_server") { (dataArray, socketAck) -> Void in
            
            print(dataArray[0])
            let message = dataArray[0] as! String
        }
    }*/
}
