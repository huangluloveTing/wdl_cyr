//
//  OfferModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/21.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation

// 有车报价 ， 驾驶员 model
struct OfferWithTruckDriverModel {
    var driverName : String = "" // 驾驶员名称
    var idCard:String = "" // 身份证号码
    var phone:String = "" // 手机号码
}

// 有车报价 ， 车辆 model
struct OfferWithTruckModel {
    var truckNo:String = "" // 车牌号码
    var truckType:String = "" // 车型
    var truckLength:String = "" // 车长
    var truckWeight:String = "" // 载重
}

// 有车报价的相关 model
struct OfferWithTruckCommitModel {
    var carrierName:String = "" //承运人名
    var driverModel:OfferWithTruckDriverModel?
    var truckModel:OfferWithTruckModel?
    var offerUnitPrice:Float = 0
    var total:Float = 0
    var serviceFee:Float = 0 // 服务费
    var myBalance:Float = 0  // 我的余额
}
