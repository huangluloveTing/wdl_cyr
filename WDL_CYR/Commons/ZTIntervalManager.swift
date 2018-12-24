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
    
    typealias ZTIntervalTimeClosure = () -> (TimeInterval)
    
    private var closure:ZTIntervalClosure?
    
    private var cacheTime : TimeInterval?
    private var timeInterval : TimeInterval  = 30 * 3600
    
    public var intervalTimeClosure : ZTIntervalTimeClosure?
    
    lazy private var linkDisplay : CADisplayLink = {
        var linker =  CADisplayLink(target: self, selector: #selector(dispathIntervalHandler))
        return linker
    }()
    
    
    @objc func dispathIntervalHandler() -> Void {
        if let closure = self.closure {
            if let timeClosure = self.intervalTimeClosure {
                self.timeInterval = timeClosure()
            }
            assert(self.timeInterval >= 0 , "传入的间隔不能小于0")
            let currentTime = Date().timeIntervalSince1970
            if cacheTime == nil || cacheTime == 0 {
                closure()
                cacheTime = currentTime
            }
            if (currentTime - cacheTime!) >= self.timeInterval {
                closure()
                cacheTime = currentTime
            }
        }
    }
    
    private override init() {
        super.init()
        self.linkDisplay.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    static public func instance(closure:ZTIntervalClosure?) -> ZTIntervalManager {
        let manager = intervalManager;
        manager.closure = closure
        return intervalManager;
    }
    
    deinit {
        if self.linkDisplay.isPaused == false {
            self.linkDisplay.invalidate()
        }
    }
}
