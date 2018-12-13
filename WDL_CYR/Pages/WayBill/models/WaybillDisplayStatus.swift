//
//  WaybillStatus.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/13.
//  Copyright © 2018 yinli. All rights reserved.
//

import Foundation

enum WaybillCommentStatus {
    case cannotComment             // 不能评价
    case noComment                 // 未评价
    case myAlreadyCommented        // 我已评价
    case commentToMe               // 已评价我 的
    case commentAll                // 已互评
}

enum WaybillDisplayStatus {
    case unAssemble_comType_1_2_noAccept    // 运单来源为1、2 时 的未接受的运单
    case unAssemble_comType_1_2_self        // 运单来源为1、2 时 的未接受的承运人指派给别的司机的
    case unAssemble_comType_3_noAccept      // 运单来源为 3 时 的未接受的运单
    case unAssemble_comType_1_2_toAssemble  // 运单来源为1、2 时 的待配载的运单
    case unAssemble_comType_3_toAssemble    // 运单来源为 3 时 的待配载的运单
    case unAssemble_comType_4_toDesignate   // 运单来源为 4 时 的待指派的运单
    case notDone_willTransport              // 未完成 待起运的运单
    case notDone_transporting               // 未完成 运输中的运单
    case notDone_willSign                   // 未完成 待签收的运单
    case notDone_breakContractForDriver     // 未完成 司机违约的运单(待办单)
    case notDone_breakContractForCarrier    // 未完成 承运人违约的运单(待办单)
    case notDone_canEditAssemble                // 未完成 可以配置的（即z待起运的运单，都可以修改配载）
    case done(WaybillCommentStatus)         // 已完成
    case other                              // 其他，显示其他情况的
}
