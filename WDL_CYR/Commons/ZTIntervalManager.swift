//
//  ZTIntervalManager.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/24.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class ZTIntervalManager : NSObject {
    
    private static let intervalManager = ZTIntervalManager()
    
    typealias ZTIntervalClosure = () -> ()
    
    private var closure:ZTIntervalClosure?
    
    private var interval : TimeInterval = 30
    private var cacheTime : TimeInterval?
    
    lazy private var linkDisplay : CADisplayLink = {
        var linker =  CADisplayLink(target: self, selector: #selector(dispathIntervalHandler))
        return linker
    }()
    
    
    @objc func dispathIntervalHandler() -> Void {
        if let closure = self.closure {
            let currentTime = Date().timeIntervalSince1970
            if cacheTime == nil || cacheTime == 0 {
                closure()
                cacheTime = currentTime
            }
            if (currentTime - cacheTime!) >= interval {
                closure()
                cacheTime = currentTime
            }
        }
    }
    
    private override init() {
        super.init()
        self.linkDisplay.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    static public func instance(timeInterval:TimeInterval , closure:ZTIntervalClosure?) -> ZTIntervalManager {
        let manager = intervalManager;
        manager.interval = timeInterval
        manager.closure = closure
        assert(timeInterval >= 0 , "传入的间隔不能小于0")
        return intervalManager;
    }
    
    deinit {
        if self.linkDisplay.isPaused == false {
            self.linkDisplay.invalidate()
        }
    }
}
