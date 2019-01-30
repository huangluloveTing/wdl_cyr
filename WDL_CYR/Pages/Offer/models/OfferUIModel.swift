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
    case bidding = 1 //  竞价中
    case rejected = 0   //  已驳回
    case canceled = 3  //  已取消
    case notDeal  = 2   //  未成交
    case dealed = 5     // 已完成
    case willDesignate = 6      // 待指派
    case other = 4
}

struct OfferUIModel {
    var possible:String = ""    // 可能性 高中低
    var unitPrice:Float = 0
    var totalPrice:Float = 0
    var start:String = ""
    var end:String = ""
    var truckInfo:String = ""
    var goodsInfo:String = ""
    var isSelf:Bool = false // 是否自营
    var company:String = ""
    var isAttention:Bool = false // 是否关注
    var reportStatus:WDLOfferDealStatus = .reject // 报价状态
//    var designateStatus : Int = 0 // 指派状态
    var avatorURL:String = ""//头像
    var id:String = ""
    
}

// 货源信息
struct GSInfoModel {
    var reportStatus:WDLOfferDealStatus = .reject // 报价状态
    var status:SourceStatus = .other
    var start:String = ""
    var end:String = ""
    var loadTime:TimeInterval = 0
    var goodsName:String = ""
    var goodsType:String = ""
    var goodsSummer:String = "" // 货品简介
    var referenceUnitPrice:Float = 0
    var referenceTotalPrice:Float = 0
    var remark:String?
    var id:String?
    var dealWay:Int? // 成交方式 1=自动 2=手动
    // 参考价是否可见 1=可见 2=不可见
    var refercnecePriceIsVisable : Int = 0
    
}

// 报价信息
struct OfferInfoModel {
    var offerName:String = ""
    var offerUnitPrice:Float = 0
    var offerTotalPrice:Float = 0
    var dealPossible:String = ""  // 成交可能性
    var showOffer:Bool = true
    

}


