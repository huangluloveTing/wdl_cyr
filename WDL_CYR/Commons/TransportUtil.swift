//
//  TransportUtil.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/29.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class TransportUtil: NSObject {
    
    //MARK: - 根据运单状态，配载对应的显示状态
    static func configWaybillDisplayStatus(info:WayBillInfoBean) -> WaybillDisplayStatus {
        let transportStatus = info.transportStatus ?? 0 // 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派
        let comType = info.comeType ?? 1         // 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= ,
        let driverStatus = info.driverStatus ?? 0 // 司机状态 0=未配载 1=TMS指派 (只要生成定单，就表明一定是已指派)2=无车竞价待指派 3=拒绝指派 4=接受指派 5=已配载 6=已违约 7=违约继续承运 8=违约放弃承运 ,
        let role = info.role            // 1 承运人 ，2 司机
        let evalate = (info.evaluateCode != nil)
        let completeStatus = info.completeStatus //运单状态 1：未配载，2 ：未完成， 3：完成 ,
        // 未配载，只需判断配置相关的字段，即 completeStatus = 1
        if completeStatus == 1 { // 未配载
            if comType == 1 || comType == 2 {   // 来源1 , 2 ， 未接受时 ， 显示 接受 拒绝
                if driverStatus == 4 {  // 当driverStatus == 4 时 ， 已接受，显示 配载
                    return .unAssemble_comType_1_2_toAssemble
                }
                return .unAssemble_comType_1_2_noAccept // 未配载，订单状态 就是 待办单 transportStatus = 0 ，
            }
            if comType == 3 {  // 来源1 , 2 ， 未接受时 ， 显示 接受 拒绝
                if driverStatus == 4 {  // 当driverStatus == 4 时 ， 已接受，显示 配载
                    return .unAssemble_comType_3_toAssemble
                }
                return .unAssemble_comType_3_noAccept // 未配载，订单状态 就是 待办单 transportStatus = 0 ，
            }
            if comType == 4 {  // 来源 4 ， 显示 指派
                return .unAssemble_comType_4_toDesignate // 未配载，订单状态 就是 待办单 transportStatus = 0 ，
            }
        }
        // 未配载，只需判断配置相关的字段，即 completeStatus = 1
        if completeStatus == 2 { // 未完成
            // 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派
            if transportStatus == 1 {
                return .notDone_willTransport
            }
            if transportStatus == 2 {
                return .notDone_transporting
            }
            if transportStatus == 3 {
                return .notDone_willSign
            }
            if driverStatus ==  6 {
                if role == 2 {
                    return .notDone_breakContractForDriver
                }
                return .notDone_breakContractForCarrier
            }
        }
        if completeStatus == 3 { // 已完成
            if evalate == true {
                return .done(.myAlreadyCommented)
            }
            return .done(.noComment)
        }
        return .other
    }

}
