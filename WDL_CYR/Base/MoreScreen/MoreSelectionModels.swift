//
//  MoreSelectionModels.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/12/12.
//  Copyright © 2018 yinli. All rights reserved.
//

import Foundation
import HandyJSON

enum MoreScreenItemType {
    case input
    case multiSelect
}

enum MoreScreenQueryKey : String {
    case vehicleWidth = "vehicleWidth"
    case vehicleType = "vehicleType"
    case vehicleLength = "vehicleLength"
    case vehicleWeight = "vehicleWeight"
    case loadingTime = "loadingTime"
    case consignorName = "consignorName"
    case weightStr = "weightStr"
}

struct MoreScreenSelectionItem {
    var title: String = ""
    var type: MoreScreenItemType = .multiSelect
    var items: [MoreScreenItem] = []
    var queryKey: MoreScreenQueryKey?
    var inputItem: MoreScreenInputItem?
}


struct MoreScreenItem {
    var title:String = ""
    var select: Bool = false
}

struct MoreScreenInputItem {
    var input:String = ""
    var placeholder: String = ""
}

struct MoreChooseItems:HandyJSON {
    var OrderTonsLimit : [HallItem] = []// 吨位
    var VehicleLength: [HallItem] = []  // 车长
    var VehicleType: [HallItem] = []    // 车型
    var LoadingTime: [HallItem] = []    // 装货时间
    var VehicleWidth: [HallItem] = []   // 车宽数据
}
