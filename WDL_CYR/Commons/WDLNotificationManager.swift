//
//  WDLNotificationManager.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/7.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

public let PUSH_MESSAGE_ACTIVE_NAME = "PUSH_MESSAGE_ACTIVE_NAME"

class WDLNotificationManager: NSObject {
    
    private var lisnters:[(Any?)->()] = []
    
    private override init() {
        super.init()
        self.pushMessageReceiveHandle()
    }
    
    private static let manager = WDLNotificationManager()
    
    static public func shared() -> WDLNotificationManager {
        return manager
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WDLNotificationManager {
    // 添加推送消息 的 通知
    func registerPushMessageCenter() -> Void {
        NotificationCenter.default.post(name: .init(PUSH_MESSAGE_ACTIVE_NAME), object: nil)
    }
    
    // 添加监听对象
    func addLisnterClosure(_ closure:((Any?)->())?) -> Void {
        if let closure = closure {
            self.lisnters.append(closure)
        }
    }
    
    // 添加接收推送消息，并响应
    func pushMessageReceiveHandle() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandleCenter(notification:)), name: .init(PUSH_MESSAGE_ACTIVE_NAME), object: nil)
    }
    
    @objc func notificationHandleCenter(notification:Notification) -> Void {
        let name = notification.name
        self.lisnters.forEach { (fc) in
            fc(name)
        }
    }
}
