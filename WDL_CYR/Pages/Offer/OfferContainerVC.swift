//
//  OfferContainerVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferContainerVC: ZTScrollViewConroller {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubController()
        self.wr_setStatusBarStyle(UIStatusBarStyle.lightContent)
        self.wr_setNavBarBarTintColor(UIColor(hex: "06C06F"))
        self.wr_setNavBarTintColor(UIColor.white)
        self.wr_setNavBarTitleColor(UIColor.white)
        self.setTitleTintColor(color: UIColor.white.withAlphaComponent(0.7), state: .normal)
        self.setTitleTintColor(color: UIColor.white, state: .selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OfferContainerVC {
    
    func addSubController() -> Void {
        let notDoneVC = OfferNotDoneVC()
        let dealVC = OfferDealVC()
        
        let subItem1 = ZTScrollItem(viewController: notDoneVC, title: "未完成")
        let subItem2 = ZTScrollItem(viewController: dealVC, title: "已完成")
        self.scrollSubItems(items: [subItem1 , subItem2])
    }
}
