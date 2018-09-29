//
//  UIResponder+Chain.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

extension UIResponder {
    
    // 通过响应者链传递数据
    public func routeName(routeName:String , dataInfo:Any) {
        self.next?.routeName(routeName: routeName, dataInfo: dataInfo)
    }
    
}
