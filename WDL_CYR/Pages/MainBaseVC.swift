//
//  MainBaseVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/24.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class MainBaseVC: BaseVC {
    
    public let GoodsStatus = ["不限","竞价中","已成交","未上架","已上架"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wr_setStatusBarStyle(UIStatusBarStyle.lightContent)
        self.wr_setNavBarBarTintColor(UIColor(hex: "06C06F"))
        self.wr_setNavBarTintColor(UIColor.white)
        self.wr_setNavBarTitleColor(UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 状态 选择的回调
    func statusChooseHandle(index:Int) -> Void {}
    
    // 时间选择的 回调
    func timeChooseHandle(startTime:TimeInterval? , endTime:TimeInterval? , tapSure sure:Bool) -> Void {}
    
    
    func statusDropViewGenerate(statusTitles:[String]) -> GoodsSupplyStatusDropView {
        let statusView = GoodsSupplyStatusDropView(tags: statusTitles)
        statusView.checkClosure = { [weak self] (index) in
            self?.statusChooseHandle(index: index)
        }
        return statusView
    }
    
    func startAndEndTimeChooseViewGenerate() -> DropInputDateView {
        let dropInputView = DropInputDateView.instanceDateView()
        dropInputView.dropInputClosure = {[weak self] (start , end , isSure) in
            self?.timeChooseHandle(startTime: start, endTime: end, tapSure: isSure)
        }
        return dropInputView
    }
}


extension MainBaseVC {
    
    
}

