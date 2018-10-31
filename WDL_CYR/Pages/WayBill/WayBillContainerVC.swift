//
//  WayBillContainerVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillContainerVC: ZTScrollViewConroller  {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wr_setStatusBarStyle(UIStatusBarStyle.lightContent)
        self.wr_setNavBarBarTintColor(UIColor(hex: "06C06F"))
        self.wr_setNavBarTintColor(UIColor.white)
        self.wr_setNavBarTitleColor(UIColor.white)
        self.setTitleTintColor(color: UIColor.white.withAlphaComponent(0.7), state: .normal)
        self.setTitleTintColor(color: UIColor.white, state: .selected)
        self.addWaybillVCs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WayBillContainerVC {
    
    func addWaybillVCs() -> Void {
        let unassemble = WaybillUnAssembleVC()
        let notDoneVC = WaybillNotDoneVC()
        let doneVC = WaybillDoneVC()
        
        let subItem1 = ZTScrollItem(viewController: unassemble, title: "未配载")
        let subItem2 = ZTScrollItem(viewController: notDoneVC, title: "未完成")
        let subItem3 = ZTScrollItem(viewController: doneVC, title: "已完成")
        self.scrollSubItems(items: [subItem1 , subItem2 , subItem3])
    }
    
    


}
