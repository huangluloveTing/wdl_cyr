
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



struct WayBillInfoBean : HandyJSON {
    var comeType  : Int?// (integer): 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= ,
    var companyLogo : String? // 托运人 logo
    var consignorName : String? // (string): 托运人名称 ,
    var carrierName : String? // (string): 承运人名称 ,
    var carrierType : String? //(string): 报价类型 0=无车报价 1=有车报价 ,
    var role  : Int? //承运人角色，1：承运人， 2，司机
    var origin : String? // (string): 起始地
    var destination :String? // (string): 目的地 ,
    var loadingTime : String? // (string): 装货时间 ,
    var goodsName :String? //  (string): 货品名称 ,
    var createTime :String?  //v成交时间 ,（指定时间）
    var goodsWeight : String? // (number): 货源总重 ,
    var vehicleLength : String? // (string): 车长 ,
    var vehicleType : String? // (string): 车型 ,
    var packageType : String? //  (string): 包装类型 ,（无包装）
    var refercneceTotalPrice : NSNumber? //  (number): 参考总价 ,
    var refercneceUnitPrice : NSNumber? //(number): 参考单价 ,
    var transportNo : String? // (string): 运单号 ,
    var transportStatus : Int? // (integer): 运单状态 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派 ,
    var evaluateCode :String? //  (string): 不为空，表示承运人已经评价 ,
    var hallId : String? // 货源id ,
    var driverStatus : Int? // (integer): 当前司机是否接受过改订单  4=接受指派，接受指派隐藏按钮，否则现实两个按钮
    
    //  driverStatus 可用于判断违约状态 6=已违约 7=违约继续承运 8=违约放弃承运    ，承运人状态 0=未配载 1=TMS指派 (只要生成定单，就表明一定是已指派)2=无车竞价待指派 3=拒绝指派 4=接受指派 5=已配载 ,
    
    var driverId :String? // ( (string): 司机id ,
    var carrierId :String? // (string): 承运人id ,
    var orderAvailabilityPeriod : String? //(string): 货源有效期 ,
    
    var goodsType : String? // (string): 货品分类 ,
    var publishTime :String? // (string): 发布时间 ,
    var shipperCode : String? // (string): 不为空表示已经关注 ,
    var transportId : String? //  (string): 运单id ,
    var vehicleWidth : String? // (string): 车宽
 
}

