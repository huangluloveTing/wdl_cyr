//
//  QuerytTransportListBean.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/16.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import HandyJSON

struct QuerytTransportListBean: HandyJSON {
    var carrierId: String? //(string, optional)承运人id,
    var consignorName: String? // (string): 承运人名称 ,
    var endCity : String? // (string): 收货地市 ,
    var endDistrict : String? // (string): 收货区 ,
    var endProvince : String? // (string): 收货地省 ,
    var pageNum : Int = 1 // (integer): 当前页数 ,
    var pageSize : Int = 20 // (integer): 页面大小 ,
    var startCity : String? // (string): 发货地市 ,
    var startDistrict : String? // (string): 发货区 ,
    var startProvince : String? // (string): 发货地省 ,
    
    var token : String? // (string): 登录token,
    var searchWord : String?//(string, optional): 搜索框值 ,
    var startTime : String? // (string): 开始时间  ,
    var endTime : String? // (string): 结束时间 ,
    var completeStatus : Int?  //(integer, optional): 顶部按钮状态 1：未配载，2 ：未完成， 3：完成 ,
    var transportStatus : Int? // (integer): 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收  -1 不限
}

struct WayBillDetailCommentInfo : HandyJSON {
    var rate:CGFloat?
    var comment:String?
    var commentTime:TimeInterval?
}
