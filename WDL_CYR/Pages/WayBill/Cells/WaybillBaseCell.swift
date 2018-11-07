//
//  WaybillBaseCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

//let Unassemble_Reject       = "Unassemble_Reject"       // 未配载拒绝
//let Unassemble_Receive      = "Unassemble_Receive"      // 未配载接受
//let Unassemble_Designate    = "Unassemble_Designate"    // 未配载未接受去指派
//let Received_Designate      = "Received_Designate"      // 未配载已接受去指派
//let Unassemble_ToAssemble   = "Unassemble_ToAssemble"   // 未配载去配载
//let assemble_EditAssemble   = "assemble_EditAssemble"   // 未完成去修改配载
//let NoPromise_ToCancelTrans = "NoPromise_ToCancelTrans" // 违约取消运输
//let NoPromise_ToContinue    = "NoPromise_ToContinue"    // 违约继续运输

let EVENT_NAME_REJECT = "EVENT_NAME_REJECT"                     // 拒绝
let EVENT_NAME_RECEIVE = "EVENT_NAME_RECEIVE"                   // 接受
let EVENT_NAME_CANCELTRANSPORT = "EVENT_NAME_CANCELTRANSPORT"   // 取消运输
let EVENT_NAME_CONTINUETRANSPORT = "EVENT_NAME_CONTINUETRANSPORT"   // 继续运输
let EVENT_NAME_DESIGNATE = "EVENT_NAME_DESIGNATE"               // 指派
let EVENT_NAME_ASSEMBLE = "EVENT_NAME_ASSEMBLE"                 // 指派

enum CurrentStatus : Int{
    case unassemble = 1
    case doing = 2
    case done = 3
}

class WaybillBaseCell: BaseCell {
    
    public var currentStatus:CurrentStatus = .unassemble

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//
extension WaybillBaseCell {
    
    // 点击拒绝
    func rejectWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_REJECT, dataInfo: param)
    }
    
    // 点击接受
    func receiveWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_RECEIVE, dataInfo: param)
    }
    
    // 点击指派
    func toDesignateWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_DESIGNATE, dataInfo: param)
    }
    
    // 点击配载
    func toAssembleWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_ASSEMBLE, dataInfo: param)
    }
    
    // 点击继续运输
    func toContinueTransformWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_CONTINUETRANSPORT, dataInfo: param)
    }
    
    // 点击取消运输
    func toCancelTransformWaybill<T>(param:T) -> Void {
        self.routeName(routeName: EVENT_NAME_CONTINUETRANSPORT, dataInfo: param)
    }
}


// 根据运单状态 ， 添加 状态标识
extension WaybillBaseCell {
    
    //TODO: 根据状态，添加对应的状态标识
    func toShowWaybillStatusSign(status:Int , for imageView:UIImageView) -> Void {
        
    }
    
    //TODO: 根据状态，配载状态
    func configStatus(status:Int , statusLabel:UILabel , comment:String?) -> Void {
        statusLabel.textColor = UIColor(hex: COLOR_BUTTON)
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        if status == 0 {
            statusLabel.text = "待办单"
        }
        if status == 1 {
            statusLabel.text = "待起运"
        }
        if status == 2 {
            statusLabel.text = "运输中"
        }
        if status == 3 {
            statusLabel.text = "待签收"
        }
        
        if status > 3 {
            if comment == nil {
                statusLabel.text = "待评价"
            } else {
                statusLabel.text = "已评价"
            }
        }
    }
    
    // 4种类型判断展示 comeType: 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= 个人指派（按照rp顺序）,
    //TODO: - 根据订单来源，展示 托运人 信息 ， 是否自营，是否是运输计划 指定等信息
    func showFirstLineInfo(info:WayBillInfoBean? ,
                           tyLabel:UILabel ,
                           middleLabel:UILabel ,
                           lastLabel:UILabel) -> Void {
        tyLabel.text = info?.consignorName
        if info?.comeType == 1 { //其他承运人指派
            middleLabel.text = "承运人:" + (info?.carrierName ?? "")
            middleLabel.textColor = UIColor(hex: "8888888")
            lastLabel.text = "转给你"
        }
        if info?.comeType == 2 { //tms指派
            middleLabel.text = "【自营】"
            middleLabel.textColor = UIColor(hex: "06C06F")
            lastLabel.text = "指定你的"
        }
        if info?.comeType == 3 { //tms指派
            middleLabel.text = "【自营】运输计划"
            middleLabel.textColor = UIColor(hex: "06C06F")
            lastLabel.text = "指定你的"
        }
        if info?.comeType == 4 { //tms指派
            middleLabel.text = "【自营】"
            middleLabel.textColor = UIColor(hex: "06C06F")
            lastLabel.text = ""
        }
        if info?.transportStatus == 0 { // 待办单已违约
            if info?.driverStatus == 6 {
                middleLabel.text = "已违约"
                middleLabel.textColor = UIColor(hex: "06C06F")
                lastLabel.text = ""
            }
        }
    }
}
