//
//  ResourceContainerVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ResourceContainerVC: ZTScrollViewConroller {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addVCs()
        self.wr_setStatusBarStyle(UIStatusBarStyle.lightContent)
        self.wr_setNavBarBarTintColor(UIColor(hex: "06C06F"))
        self.wr_setNavBarTintColor(UIColor.white)
        self.wr_setNavBarTitleColor(UIColor.white)
        self.setTitleTintColor(color: UIColor.white.withAlphaComponent(0.7), state: .normal)
        self.setTitleTintColor(color: UIColor.white, state: .selected)
        self.addMessageRihgtItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessageNumRequest()
    }
    
    //MARK ; - 关闭横向滚动
    override func horiScrolEnable() -> Bool {
        return false
    }
    
}

extension ResourceContainerVC {
    
    private func addVCs() {
        let focus = FocusResourceVC()
        let resourceHall = ResourceHallVC()
        
        let subItem1 = ZTScrollItem(viewController: focus, title: "关注货源")
        let subItem2 = ZTScrollItem(viewController: resourceHall, title: "货源大厅")
        self.scrollSubItems(items: [subItem1 , subItem2])

    }
    
}


