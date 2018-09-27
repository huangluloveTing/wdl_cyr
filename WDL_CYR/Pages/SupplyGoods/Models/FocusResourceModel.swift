//
//  FocusResourceModel.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

struct SupplyPlaceModel {
    var province:PlaceChooiceItem?
    var city : PlaceChooiceItem?
    var strict : PlaceChooiceItem?
}

// 货源大厅 的 item 的 model
struct ResourceHallUIModel {
    var start:String = ""
    var end:String = ""
    var truckInfo:String = ""
    var goodsInfo:String = ""
    var isSelf:Bool = false // 是否自营
    var company:String = ""
    var isAttention:Bool = false // 是否关注
    var unitPrice:Float = 0 // 单价
    var reportNum:Int = 0 // 报价人数
}
