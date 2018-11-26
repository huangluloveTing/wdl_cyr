//
//  CarrierQueryOrderHallResult.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/8.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import HandyJSON

struct CarrierQueryOrderHallResult : HandyJSON {
    var autoTimeInterval : TimeInterval = 0 //自动成交时间间隔 ,
    var bidPriceWay : Int = 0// (integer, optional),
    var carrierType : String = "" // (string, optional),
    var companyName : String = "" // (string): 企业名称 ,
    var carrierName : String = "" // (string): 承运人名称 ,
    var consigneeName : String = "" // (string, optional),
    var consigneePhone : String = "" // (string, optional),
    var consignorName : String = "" // (string): 拖运人名称 ,
    var consignorNo : String = "" // (string): 托运人ID ,
    var consignorType : String = ""// (integer): 企业性质 ,
    var createTime : TimeInterval = 0 // (string, optional),
    var dealTime : TimeInterval = 0 // (string): 成交时间 ,
    var dealTotalPrice : Float = 0 // (number): 成交总价 ,
    var dealUnitPrice : Float = 0 // (number): 成交单价 ,
    var dealWay : Int = 0 // (integer): 成交方式 1=自动 2=手动 ,
    var endAddress : String = "" // (string, optional),
    var endCity : String = "" // (string): 收货地市 ,
    var endDistrict : String = "" // (string): 收货区 ,
    var endProvince : String = "" // (string): 收货地省 ,
    var endTime : TimeInterval = 0 // (string): 结束时间 ,
    var freightunit : String = "" // (string, optional),
    var goodsName : String = "" // (string): 货品名称 ,
    var goodsType : String = "" // (string): 货品分类 ,
    var goodsWeight : Float = 0 // (number): 货源总重 ,
    var id : String = "" // (string, optional),
    var infoFee : Float = 0  // (number): 服务费 ,
    var isDeal : Int = 0 // (integer): 订单状态0=竞价中 1=成交 2=未上架 3=已下架 ,
    var isEnable : Int = 0 // (integer, optional),
    var isVisable : Int = 0 // (integer): 是否可见 ,
    var loadingTime : TimeInterval = 0 // (string): 装货时间 ,
    var offerNumber : Int = 0 // (integer): 报价数量 ,
    var offerType : Int = 0 // (integer, optional),
    var offerWay : Int = 0 // (integer): 报价方式[1：有车报价 2：无车报价] ,
    var orderAvailabilityPeriod : String = "" // (string): 货源有效期 ,
    var packageType : String = "" // (string): 包装类型 ,
    var pageNum : Int = 0 // (integer): 当前页数 ,
    var pageSize : Int = 0 // (integer): 页面大小 ,
    var payType : String = "" // (string, optional),
    var publishTime : TimeInterval = 0 // (string): 发布时间 ,
    var refercnecePriceIsVisable : String = "" // (string, optional),
    var refercneceTotalPrice : Float = 0 // (number): 参考总价 ,
    var refercneceUnitPrice : Float = 0 // (number): 参考单价 ,
    var remark : String = "" //(string, optional),
    var shipperCode : String = "" // (string): 字段不为空表示关注 ,
    var startAddress : String = "" //  (string, optional),
    var startCity : String = ""  //(string): 发货地市 ,
    var startDistrict : String = "" // (string): 发货区 ,
    var startProvince : String = "" // (string): 发货地省 ,
    var startTime : TimeInterval = 0 // (string): 开始时间 ,
    var stowageNo : String = "" // (string): 配载单号 ,
    var transportWay : String = "" // (string, optional),
    var unableReason : String = "" // (string): 下架原因 ,
    var vehicleLength : String = "" // (string): 车长 ,
    var vehicleType : String = "" // (string): 车型 ,
    var vehicleWidth : String = "" // (string): 车宽
    var companyLogo : String = ""//公司头像
    var sourceType : Int = 1 // (integer): 货源来源 1:来至ZBN，2:来至TMS , 3:来自SAP ,
}

//已经关注托运人下的货源信息
struct FollowShipperOrderHall : HandyJSON {
    var consignorId : String = "" // (string): 托运人ID ,
    var consignorName : String = "" // (string): 托运人姓名 ,
    var companyName : String = "" // (string): 托运人公司 ,
    var hall : [CarrierQueryOrderHallResult] = [] // 货运订单信息 ,
    var loginPath: String  = "" //公司logO
    var total : Int = 0 // (integer): 运单总数
}

struct FollowLineOrderHallResult : HandyJSON {
    var endCity : String?     // (string): 收货地市 ,
    var endProvince : String? // (string): 收货地省 ,
    var hall : [CarrierQueryOrderHallResult] = [] // 线路下，货源信息 ,
    var lineCode : String?    // (string): 线路ID或者货主的ID ,
    var startCity : String?   // (string): 发货地市 ,
    var startProvince : String? // (string): 发货地省 ,
    var total : Int = 0       // (integer): 线路下，货源订单总数
}

struct FollowFocusLineOrderHallResult : HandyJSON {
    public var endCity : String?     // (string): 收货地市 ,
    public var endProvince : String? // (string): 收货地省 ,
    public var hall : [CarrierQueryOrderHallResult] = [] // 线路下，货源信息 ,
    public var lineCode : String?    // (string): 线路ID或者货主的ID ,
    public var startCity : String?   // (string): 发货地市 ,
    public var startProvince : String? // (string): 发货地省 ,
    public var total : Int = 0       // (integer): 线路下，货源订单总数
}

//取消关注托运人
struct CancerFouceCarrier : HandyJSON {
    var code : String = "" // 线路编码或托运人编码 ,
    var endTime : String = "" // 结束时间 ,
    var startTime : String = "" // 开始时间
    var pageNum: Int  = 1 //当前页数
    var token : String = ""
}
