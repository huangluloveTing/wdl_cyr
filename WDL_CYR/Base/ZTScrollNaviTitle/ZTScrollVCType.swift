//
//  ZTScrollVCType.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

protocol ZTScrollViewControllerType {
    func willShow()
    func didShow()
    func willDisappear()
}


protocol ZTScrollVCContainerType {
    associatedtype SubVCType
    func scrollSubItems(items:SubVCType)
}
