//
//  ResponseBaseModel.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/8.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import HandyJSON

struct ResponsePagesModel<T:HandyJSON> : HandyJSON {
    var list : [T]? // (Array[CarrierQueryOrderHallResult], optional),
    var pageNum : Int = 0 // (integer, optional),
    var pageSize : Int = 0 // (integer, optional),
    var size : Int = 0 // (integer, optional),
    var startRow : Int = 0 // (integer, optional),
    var total : Int = 0 // (integer, optional)
}
