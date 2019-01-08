//
//  OfferResultModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/23.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit
import HandyJSON

// 订单报价状态
enum WDLOfferDealStatus : Int , HandyJSONEnum {
    case reject = 0        // 驳回
    case inbinding = 1     // 竞价中
    case deal = 2          // 成交
    case done = 3          // 完成
    case willDesignate = 4 // 待指派
    case canceled = 5      // 已取消
    case notDone = 6       // 未完成
    
}

struct OfferOrderHallResultApp : HandyJSON {
    
    
    // 自己添加的
    var hallId : String = ""
    // 自动成交时间间隔（小时）
    var autoTimeInterval : TimeInterval = 0
    // 竞价方式 1=自由 2=指派
    var bidPriceWay : Int = 0
    // 承运人ID
    var carrierId : String = ""
    // 承运人名称
    var carrierName : String = ""
    // 承运方式 (1-单车运输)
    var carrierType : String = ""
    
    // 企业头像
    var companyLogo : String = ""
    // 企业名称
    var companyName : String = ""
    // 收货人
    var consigneeName : String = ""
    // 收货人联系电话
    var consigneePhone : String = ""
    // 拖运人名称
    var consignorName : String = ""
    // 托运人ID
    var consignorNo : String = ""
    // 企业性质 属性 1=经销商 2=第三方 ,
    var consignorType : Int = 0
    // 创建时间
    var createTime : TimeInterval = 0
    // 报价的成交状态 0=驳回 1=竞价中 2=成交 3=已取消
    var dealStatus : WDLOfferDealStatus = .reject
    // 成交时间
    var dealTime : TimeInterval = 0
    // 成交总价
    var dealTotalPrice : Float = 0
    // 成交单价
    var dealUnitPrice : Float = 0
    // 成交方式 1=自动 2=手动
    var dealWay : Int = 0
    // 收货详细地址
    var endAddress : String = ""
    // 收货地市
    var endCity : String = ""
    // 收货区
    var endDistrict  :String = ""
    // 收货地省
    var endProvince : String = ""
    // 结束时间
    var endTime : TimeInterval = 0
    // 结算单位
    var freightunit : String = ""
    // 货品名称
    var goodsName : String = ""
    // 货品分类
    var goodsType : String = ""
    //  (number): 货源总重 ,
    var goodsWeight : Float = 0
    var id : String  = ""
    //  (number): 服务费 ,
    var infoFee :Float = 0
    // (integer): 是否成交 0=竞价中 1=成交 2=未上架 3=已下架
    var isDeal : Int = 0
    //  (integer): 上下架 0=下架 1=上架 ,
    var isEnable : Int = 0
    //  承运人是否已经报价 ，不为空，表示当前承运人已经报价 ,
    var isOffer : String?
    //  (integer): 是否可见 1=全部可见 2=部分可见
    var isVisable : Int = 1
    // 装货联系人 ,
    var loadingPersonName : String = ""
    // 装货联系人电话
    var loadingPersonPhone : String = ""
    // 装货时间
    var loadingTime : TimeInterval = 0
    // 报价ID
    var offerId : String = ""
    // 报价数量 ,
    var offerNumber : Int = 0
    // 可能性 高中低
    var offerPossibility : String = ""
    // 报价时间
    var offerTime : String = ""
    // 报价类型[1：明报，2：暗报]
    var offerType : Int = 0
    // 报价方式[1：有车报价 2：无车报价]
    var offerWay : Int = 1
    // 货源有效期
    var orderAvailabilityPeriod : TimeInterval = 0
    // 包装类型
    var packageType : String = ""
    //  当前页数
    var pageNum : Int = 0
    // 页面大小
    var pageSize : Int = 0
    // 支付类型（0-现金）
    var payType : Int = 0
    // 发布时间
    var publishTime : TimeInterval = 0
    // 报价单价
    var quotedPrice : Float = 0
    // 参考价是否可见 1=可见 2=不可见
    var refercnecePriceIsVisable : Int = 0
    // 参考总价
    var refercneceTotalPrice : Float = 0
    // 参考单价
    var refercneceUnitPrice : Float = 0
    // 备注
    var remark : String = ""
    // 字段不为空表示关注
    var shipperCode : String?
    // 订单来源 1:来至ZBN，2:来至TMS , 3:来自SAP ,
    var sourceType : Int = 1
    // 发货详细地址
    var startAddress : String = ""
    // 发货地市
    var startCity : String = ""
    // 发货区
    var startDistrict : String = ""
    // 发货地省
    var startProvince : String = ""
    // 开始时间
    var startTime : TimeInterval = 0
    // 配载单号
    var stowageNo : String = ""
    // 自动成交剩余时间秒
    var surplusTurnoverTime:TimeInterval = 0
    // 报价总价
    var totalPrice : Float = 0
    // 运输方式
    var transportWay : String = ""
    // 下架原因
    var unableReason : String = ""
    // 车长
    var vehicleLength : String = ""
    // TMS货源订单配载情况 1： 未配载 2，已配载 ,
    var vehicleStatuc : Int = 1
    // 车型
    var vehicleType : String = ""
    // 车宽
    var vehicleWidth : String = ""
    
    var transportOrderAppResult :WayBillInfoBean? // optional), 运单信息
}


struct OfferPageInfo : HandyJSON {
    var list : [OfferOrderHallResultApp]? // (Array[OfferOrderHallResultApp], optional),
    var pageNum : Int = 0
    var pageSize : Int = 0
    var total : Int = 0
}

// 根据货源获取报价信息的 报价数据 模型
struct ZbnOfferModel  : HandyJSON {
    //  (string): 承运人ID ,
    var carrierId : String = ""
    //  (string): 承运人姓名 ,
    var carrierName : String = ""
    // (string): 承运人类型 ,
    var carrierType : String = ""
    // (string): 承运人联系方式 ,
    var carrierPhone : String = ""
    // (number): 承运人综合评分 ,
    var  carrierScore : Float = 0
    // (integer): 历史成交笔数 ,
    var dealCount : Int = 0
    // (integer): 成交状态 0=驳回 1=竞价中 2=成交 3=完成 4=待指派 5=已取消 6= 未成交 ,
    var dealStatus : WDLOfferDealStatus = .reject
    // (string): 司机姓名 ,
    var driverName : String = ""
    // (string): 司机联系方式 ,
    var driverPhone : String = ""
    // (string): 结束时间 ,
    var endTime : TimeInterval = 0
    // (string): 货源ID ,
    var hallId : String = ""
    // (string, optional),
    var id : String = ""
    // (number): 承运数量 ,
    var loadWeight : Float = 0
    // (string): 可能性 高中低 ,
    var offerPossibility : String = ""
    // (string): 报价时间 ,
    var offerTime : TimeInterval = 0
    // (string): 收款人 ,
    var payee : String = ""
    // (number): 单价 ,
    var quotedPrice : Float = 0
    // (string): 开始时间 ,
    var startTime : TimeInterval = 0
    // (string): 配载单号 ,
    var stowageNo : String = ""
    // (number): 总价 ,
    var totalPrice  :Float = 0
    // (string): 车牌号
    var vehicleNo : String = ""
}


struct OrderAndOfferResult : HandyJSON {
    // 报价信息
    var offerPage : [ZbnOfferModel]?
    //  (integer): 交易剩余时间秒 ,
    var  surplusTurnoverTime : TimeInterval = 0
    //  货源信息
    var zbnOrderHall : OfferOrderHallResultApp?
}
