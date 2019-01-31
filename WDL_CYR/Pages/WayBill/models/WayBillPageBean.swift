
//
//  WayBillPageBean.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/17.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import HandyJSON
import RxDataSources


struct WayBillPageBean : HandyJSON {
    var list : [WayBillInfoBean]? //
    var pageNum : Int?
    var pageSize : Int?
    var total : Int?
}

//1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收  7=被拒绝
//当出现5或者6时，托运人就不能签收了
enum WayBillTransportStatus : Int , HandyJSONEnum { // 运单状态
    case noStart = -1           // 未开始
    case willStart = 0          // 待办单
    case willToTransport = 1   // 待起运
    case transporting = 2      // 运输中
    case willToPickup = 3      // 待签收
    case commented_one = 4      // 已评价签收
    case done = 10            // 完成（已签收）
}

struct WayBillInfoBean : HandyJSON {
    var driverId:String?
    var driverName : String? // (string): 司机姓名 ,
    var dealTotalPrice : Float = 0 // (number): 成交总价 ,
    var dealUnitPrice : Float = 0  // (number): 成交单价 ,
    var completeStatus:Int = 1 //运单状态 1：未配载，2 ：未完成， 3：完成 ,
    var carrierId : String? // (string): 承运人id ,
    var comeType  : Int? = 1 // (integer): 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= ,
    var companyLogo : String? // 托运人 logo
    var consignorName : String? // (string): 托运人名称 ,
    var carrierName : String? // (string): 承运人名称 ,
    var carrierType : Int? //(string): 报价类型 1=有车报价 2=无车报价 , ,
    var role  : Int? //承运人角色，1：承运人， 2，司机
    var origin : String? // (string): 起始地
    var destination :String? // (string): 目的地 ,
    var loadingTime : String? // (string): 装货时间 ,
    var goodsName :String? //  (string): 货品名称 ,
    var createTime :TimeInterval?  //v成交时间 ,（指定时间）
    var goodsWeight : String? // (number): 货源总重 ,
    var vehicleLength : String? // (string): 车长 ,
    var vehicleType : String? // (string): 车型 ,
    var packageType : String? //  (string): 包装类型 ,（无包装）
    var refercneceTotalPrice : Float? //  (number): 参考总价 ,
    var refercneceUnitPrice : Float? //(number): 参考单价 ,
    var sourceType : Int? // (integer): 货源来源 1:来至ZBN，2:来至TMS , 3:来自SAP
    var transportNo : String? // (string): 运单号 ,
    var transportStatus : Int? // (integer): 运单状态 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派 ,
    var evaluateCode :String? //  (string): 不为空，表示承运人已经评价 ,
    var hallId : String? // 货源id ,
    var driverStatus : Int? // (integer): 当前司机是否接受过改订单  4=接受指派，接受指派隐藏按钮，否则现实两个按钮
    //  driverStatus 可用于判断违约状态 6=已违约 7=违约继续承运 8=违约放弃承运    ，承运人状态 0=未配载 1=TMS指派 (只要生成定单，就表明一定是已指派)2=无车竞价待指派 3=拒绝指派 4=接受指派 5=已配载 ,
    var ordNo :String? // (string): 订单号 ,
    var orderAvailabilityPeriod : String? //(string): 货源有效期 ,
    
    var goodsType : String? // (string): 货品分类 ,
    var publishTime :String? // (string): 发布时间 ,
    var shipperCode : String? // (string): 不为空表示已经关注 ,
    var transportId : String? //  (string): 运单id ,
    var vehicleWidth : String? // (string): 车宽
    var startDistrict : String = ""
    var endDistrict : String = ""
    var startCity : String = ""
    var endProvince : String = ""
    var endCity : String = ""
    var startProvince : String = ""
    var id : String = ""
    var transportWeightReal: Float = 0
    var isAccepted : Int? // 1 接受，2 拒绝
//    startDistrict": "滨海新区",
//    "endDistrict": "大观区",
//    "startProvince": "天津",
//    "startCity": "天津市",
//    "endProvince": "安徽省",
//    "endCity": "安庆市",
}



struct TransactionInformation : HandyJSON {
    var driverId:String?
    var autoTimeInterval : Int? // (integer): 自动成交时间间隔 ,
    var bidPriceWay : Int?      // (integer, optional),
    var carrierName : String?   // (string): 承运人姓名 ,
    var carrierType :String?    // (string, optional),
    var cellPhone :String?      // (string): 承运人手机号 ,
    var consigneeName : String? // (string, optional),收货人
    var consigneePhone :String? // (string, optional), 收货联系人电话
    var consignorName :String?  // (string): 拖运人名称 ,
    var consignorNo : String?   // (string): 托运人ID ,
    var createTime : String?    // (string, optional),
    var dealTime : TimeInterval? // (string): 成交时间 ,
    var dealTotalPrice : CGFloat? // (number): 成交总价 ,
    var dealUnitPrice : CGFloat? // (number): 成交单价 ,
    var dealWay : Int?          // (integer): 成交方式 1=自动 2=手动 ,
    var driverName : String?    // (string): 司机姓名 ,
    var driverPhone : String?   // (string): 司机手机号 ,
    var endAddress : String?    // (string, optional),
    var endCity : String?       // (string): 收货地市 ,
    var endDistrict :String?    // (string): 收货区 ,
    var endProvince : String?   // (string): 收货地省 ,
    var endTime : TimeInterval? // (string): 结束时间 ,
    var freightunit : String?   // (string, optional),
    var goodsName : String?     // (string): 货品名称 ,
    var goodsType : String?     // (string): 货品分类 ,
    var goodsWeight : Float?   // (number): 货源总重 ,
    var transportWeight : Float?   // (number): 承运重量 ,
    var id : String?            // (string, optional),
    var infoFee : Float?       // (number): 服务费 ,
    var isDeal : String?        // (integer): 订单状态0=竞价中 1=成交 2=未上架 3=已下架 ,
    var isEnable : String?      // (integer, optional),
    var isVisable : String?     // (integer): 是否可见 ,
    var loadingTime : TimeInterval? // (string): 装货时间 ,
    var loadingPersonName : String? // (string): 装货联系人 ,
    var loadingPersonPhone : String? // (string): 装货联系人电话 ,
    var locationList : [ZbnLocation]? // (Array[ZbnLocation]): 定位信息 ,
    var offerType : String? // (integer, optional),
    var offerWay :Int? // (integer): 报价方式[1：有车报价 2：无车报价] ,
    var orderAvailabilityPeriod : String? // (string): 货源有效期 ,
    var packageType : String? // (string): 包装类型 ,
    var payType :String? // (string, optional),
    var publishTime : TimeInterval? // (string): 发布时间 ,
    var refercnecePriceIsVisable : String? // (string, optional),
    var refercneceTotalPrice : CGFloat? // (number): 参考总价 ,
    var refercneceUnitPrice : CGFloat? // (number): 参考单价 ,
    var remark : String? // (string, optional),
    var returnList : [ZbnTransportReturn]? // (Array[ZbnTransportReturn]): 回单信息 ,
    var startAddress : String? // (string, optional),
    var startCity : String? // (string): 发货地市 ,
    var startDistrict : String? // (string): 发货区 ,
    var startProvince : String? // (string): 发货地省 ,
    var startTime : TimeInterval? // (string): 开始时间 ,
    var stowageCode : String? // (string): 运单编码 ,
    var stowageNo : String? // (string): 配载单号 ,
    var supplyCode : String? // (string, optional): 货源编码 ,
    var transportStatus : WayBillTransportStatus? // (integer): 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收  7=被拒绝
    var transportNo:String? // 运单号
    var transportWay : String? // (string, optional),
    var unableReason : String? // (string): 下架原因 ,
    var vehicleLength : String? // (string): 车长 ,
    var vehicleNo :String? // (string): 车牌号 ,
    var vehicleType : String? // (string): 车型 ,
    var vehicleWidth : String? // (string): 车宽
    var ordNo :String? // (string): 订单号 ,
    var evaluateList : [ZbnEvaluate]? // 评价信息
    var vehicleStatuc : Int = 1 // (integer): TMS货源订单配载情况 1： 未配载 2，已配载 ,
    var sourceType : Int = 1    // (integer): 货源来源 1:来至ZBN，2:来至TMS , 3:来自SAP
}

struct ZbnLocation : HandyJSON { // 定位信息
    var endTime : TimeInterval? // (string): 结束时间 ,
    var id : String? // (string, optional),
    var latitude : CGFloat? //(number, optional),
    var location : String? // (string, optional),
    var longitude : CGFloat? // (number, optional),
    var startTime : TimeInterval? // (string): 开始时间 ,
    var transportNo : String? // (string, optional),
    var vehicleNo : String? // (string, optional)
}

struct ZbnTransportReturn : HandyJSON { // 回单信息 ,
    var endTime : TimeInterval? // (string): 结束时间 ,
    var id : String? // (string, optional),
    var returnBillUrl : String? // (string): 回单存储路径 ,
    var startTime : TimeInterval? // (string): 开始时间 ,
    var createTime : TimeInterval? // (string): 创建时间 ,
    var transportNo : String? // (string, optional)
}

struct ZbnEvaluate  : HandyJSON {
    var driverName : String? // (string, optional), 司机姓名
    var endTime : TimeInterval? // (string): 结束时间 ,
    var evaluateScore : CGFloat? // (integer, optional), 评分
    var evaluateTo : Int? // (integer, optional),EVALUATE_TO 谁的评价 1=托运人评价无车承运人 2=托运人评价有车承运人 3=无车承运人平均价有车承运人 4=司机评价托运人
    var id : String? // (string, optional),
    var ordCount : String? // (integer, optional), 竞价次数
    var score : Int? // (integer, optional), 得分
    var startTime : TimeInterval? // (string): 开始时间 ,
    var transportNo : String? // (string, optional) 运单号
    var transportLine : String? // (string): 线路 ,
    var transportCount : Int = 0 // (integer): 承运次数 ,
    var logisticsServicesScore : Int = 0 // (integer): 物流服务得分 ,
    var serviceAttitudeScore : Int = 0 // (integer): 服务态度 ,
    var activity : Int = 0  //(integer): 活跃度 ,
    var bidPriceCount : Int = 0 // (integer): 竞价次数 ,
    var breachCount : Int = 0 // (integer): 违约次数 ,
    var commonts : String?
    var createTime : TimeInterval = 0 // (string): 时间 ,
}

struct OrderHallReturnVo : HandyJSON {
    var imageUrl:[String] = []   // 回单图片地址 ,
    var transportNo : String = "" //(string): 运单编码省
    var latitude : Float = 0.0 //(string): 经度
    var longitude : Float = 0.0 //(string): 纬度
}
