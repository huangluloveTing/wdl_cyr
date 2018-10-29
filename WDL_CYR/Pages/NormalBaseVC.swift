//
//  NormalBaseVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/24.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class NormalBaseVC: MainBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wr_setStatusBarStyle(UIStatusBarStyle.default)
        self.wr_setNavBarBarTintColor(UIColor(hex: "F6F6F6"))
        self.wr_setNavBarTintColor(UIColor(hex: "999999"))
        self.wr_setNavBarTitleColor(UIColor(hex: "333333"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
