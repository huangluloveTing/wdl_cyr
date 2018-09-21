//
//  ContainerVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ContainerVC: ZTScrollViewConroller {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addViewControllers() {
        let vc_1 = DemoViewViewController()
        vc_1.view.backgroundColor = UIColor.red
        let vc_2 = DemoViewViewController()
        vc_2.view.backgroundColor = UIColor.blue
        let item_1 = ZTScrollItem(viewController: vc_1, title: "title_1")
        let item_2 = ZTScrollItem(viewController: vc_2, title: "title_2")
        
        self.scrollSubItems(items: [item_1 , item_2])
    }

}
