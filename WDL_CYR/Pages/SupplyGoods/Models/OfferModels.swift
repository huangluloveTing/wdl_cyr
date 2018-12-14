//
//  OfferModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/21.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation
import HandyJSON

// 有车报价 ， 驾驶员 model
struct OfferWithTruckDriverModel {
    var driverName : String = "" // 驾驶员名称
    var idCard:String = "" // 身份证号码
    var phone:String = "" // 手机号码
    var type:Int = 0        // 承运人 类型  1=司机 2=承运人 ,
    var driverId:String = ""
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
    var offerUnitPrice:Float?
    var total:Float = 0
    var serviceFee:Float = 0 // 服务费
    var myBalance:Float = 0  // 我的余额
}

// 承运报价的 model
struct CarrierOfferCommitModel : HandyJSON {
    // 承运人ID
    var carrierId : String?
    // 承运人姓名
    var carrierName : String?
    // 承运人类型
    var carrierType : Int?
    // 司机姓名
    var driverName : String?
    // 司机联系方式
    var driverPhone : String?
    // 司机id
    var driverId:String?
    // 货源ID
    var hallId : String?
    // 承运数量
    var loadWeight : Float?
    // 单价
    var quotedPrice : Float?
    // 配载单号
    var stowageNo : String?
    // 总价
    var totalPrice : Float?
    // 车牌号
    var vehicleNo : String?
    // 信息费
    var infoFee : Float?
}
