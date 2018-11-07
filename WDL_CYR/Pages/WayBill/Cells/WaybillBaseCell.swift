//
//  WaybillBaseCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

let Unassemble_Reject       = "Unassemble_Reject"       // 未配载拒绝
let Unassemble_Receive      = "Unassemble_Receive"      // 未配载接受
let Unassemble_Designate    = "Unassemble_Designate"    // 未配载未接受去指派
let Received_Designate      = "Received_Designate"      // 未配载已接受去指派
let Unassemble_ToAssemble   = "Unassemble_ToAssemble"   // 未配载去配载
let assemble_EditAssemble   = "assemble_EditAssemble"   // 未完成去修改配载
let NoPromise_ToCancelTrans = "NoPromise_ToCancelTrans" // 违约取消运输
let NoPromise_ToContinue    = "NoPromise_ToContinue"    // 违约继续运输



class WaybillBaseCell: BaseCell {

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
        self.routeName(routeName: Unassemble_Reject, dataInfo: param)
    }
    
    // 点击接受
    func receiveWaybill<T>(param:T) -> Void {
        self.routeName(routeName: Unassemble_Receive, dataInfo: param)
    }
    
    // 未接受点击指派
    func toDesignateWaybill<T>(param:T) -> Void {
        self.routeName(routeName: Unassemble_Designate, dataInfo: param)
    }
    
    // 已接受点击指派
    func receivedToDesignateWaybill<T>(param:T) -> Void {
        self.routeName(routeName: Received_Designate, dataInfo: param)
    }
    
    // 点击配载
    func toAssembleWaybill<T>(param:T) -> Void {
        self.routeName(routeName: Unassemble_ToAssemble, dataInfo: param)
    }
    
    // 点击继续运输
    func toContinueTransformWaybill<T>(param:T) -> Void {
        self.routeName(routeName: NoPromise_ToContinue, dataInfo: param)
    }
    
    // 点击取消运输
    func toCancelTransformWaybill<T>(param:T) -> Void {
        self.routeName(routeName: NoPromise_ToCancelTrans, dataInfo: param)
    }
    
    // 点击修改配载
    func toEditAssembleWaybill<T>(param:T) -> Void {
        self.routeName(routeName: assemble_EditAssemble, dataInfo: param)
    }
}


// 根据运单状态 ， 添加 状态标识
extension WaybillBaseCell {
    
    //TODO: 根据状态，添加对应的状态标识
    func toShowWaybillStatusSign(status:Int , for imageView:UIImageView) -> Void {
        
    }
    
    //TODO: - 根据订单来源，展示 托运人 信息 ， 是否自营，是否是运输计划 指定等信息
    func showFirstLineInfo(info:WayBillInfoBean? ,
                           tyLabel:UILabel ,
                           middleLabel:UILabel ,
                           lastLabel:UILabel) -> Void {
        
    }
}
