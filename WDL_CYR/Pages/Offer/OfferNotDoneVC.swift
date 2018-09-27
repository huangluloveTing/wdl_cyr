//
//  OfferNotDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferNotDoneVC: NormalBaseVC , ZTScrollViewControllerType {
    
    @IBOutlet weak var dropHintView: DropHintView!
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configDropView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// dropView
extension OfferNotDoneVC : DropHintViewDataSource {
    
    func configDropView() -> Void {
        self.dropHintView.dataSource = self
        self.dropHintView.tabTitles(titles: ["报价时间","报价状态"])
        self.dropHintView.dropTapClosure = {(index) in
            print("current tap index ： \(index)")
        }
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.zt_width, height: 100))
        if index == 0 {
            view.backgroundColor = UIColor.red

        } else {
            view.backgroundColor = UIColor.blue
        }
        return view
    }
}
