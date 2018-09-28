//
//  OfferUIModel.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

//enum OfferStatus : Int {
//
//}

// 货源状态
enum SourceStatus : Int {
    case bidding = 0 //  竞价中
    case rejected    //  已驳回
    case canceled    //  已取消
    case notDeal     //  未成交
    case other
}

struct OfferUIModel {
    var possible:String = ""
    var unitPrice:Float = 0
    var totalPrice:Float = 0
    var start:String = ""
    var end:String = ""
    var truckInfo:String = ""
    var goodsInfo:String = ""
    var isSelf:Bool = false // 是否自营
    var company:String = ""
    var isAttention:Bool = false // 是否关注
    var reportStatus:Int = 0 // 报价状态
    var designateStatus : Int = 0 // 指派状态
    var avatorURL:String = ""
}

// 货源信息
struct GSInfoModel {
    var status:SourceStatus = .other
    var start:String = ""
    var end:String = ""
    var loadTime:TimeInterval = 0
    var goodsName:String = ""
    var goodsType:String = ""
    var goodsSummer:String = "" // 货品简介
    var referenceUnitPrice:Float = 0
    var referenceTotalPrice:Float = 0
    var remark:String = ""
}

// 报价信息
struct OfferInfoModel {
    var offerName:String = ""
    var offerUnitPrice:Float = 0
    var offerTotalPrice:Float = 0
    var dealPossible:String = ""  // 成交可能性
}
