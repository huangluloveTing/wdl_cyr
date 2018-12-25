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
    var id : String = "" // (string, optional),货源编号
    var start:String = ""
    var end:String = ""
    var truckInfo:String = ""
    var goodsInfo:String = ""
    var isSelf:Bool = false // 是否自营
    var company:String = ""
    var isAttention:Bool = false // 是否关注
    var unitPrice:Float = 0 // 单价
    var companyLogo : String = ""//公司头像
    var reportNum:Int = 0 // 报价人数
    var refercneceUnitPrice : Float = 0 // (number): 参考单价 ,
    var refercnecePriceIsVisable: Int = 1 // 参考价是否可见 1=可见 2=不可见
    var isOffer:Bool = false        // 是否已报价
    
    var shipperCode : String = "" // (string): 字段不为空表示托运人关注 ,
    var followLine : Bool = true;//关注路线true ，未关注false
}

struct ResourceDetailUIModel {
    var id : String = "" // (string, optional),货源编号
    var refercneceTotalPrice:Float = 0 // 参考总价
    var refercneceUnitPrice:Float = 0 // 参考单价
    var refercnecePriceIsVisable : Int = 1 // (string, optional), 参考价是否可见，1=可见 2，不可见
//    var carrierName:String = "" // 托运人名称
    var consignorName: String = "" // 托运人名称
    var dealCount:Int = 0   // 成交数
    var rate:Float = 0      // 评分
    var isOffer:Bool = false // h是否报价
    var attention:Bool = false  // 是否关注
    var resource:CarrierQueryOrderHallResult? // 货源信息
}
