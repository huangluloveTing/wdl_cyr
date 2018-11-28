//
//  OfferQueryModel.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/23.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation
import HandyJSON

struct OfferQueryModel : HandyJSON {
    var carrierName:String? // 托运人名称/企业名称 ,
    // 成交状态 0=驳回 1=竞价中 2=成交 3=完成 4=待指派 5=已取消 6= 未成交
    var dealStatus : Int?
    // 结束时间
    var endTime : TimeInterval?
    // 开始时间
    var startTime : TimeInterval?
    // 页数
    var pageNum : Int = 1
    //
    var pageSize : Int = 20
    // 1:未完成 2：已完成
    var status : Int = 1
}

// 根据 货源ID 获取报价信息
struct OrderHallOfferQueryModel : HandyJSON {
     //  货源ID ,
    var hallId : String = ""
}
