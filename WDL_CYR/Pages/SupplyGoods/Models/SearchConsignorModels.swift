//
//  SearchConsignorModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation
import HandyJSON

// 搜索未关注托运人的model
struct ConsignorFollowShipper : HandyJSON {
    var consignorCode:String? // (string, optional),
    var consignorName:String? // (string, optional),
    var consignorType:String? // (string, optional),
    var logParh:String?         // (string, optional),
    var orderNumer:String? // (string, optional)
    var focus:Bool = false
}

//关注托运人的query模型
struct AddShipperQueryModel : HandyJSON {
    var shipperId : String = "" // (string): 托运人ID ,
    var shipperType : String = "" // (string): 托运人类型
}
