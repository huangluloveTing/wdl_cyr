//
//  WaybillCarrierInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

/// 
class WaybillCarrierInfoCell: WaybillBaseCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var desiginNameLabel: UILabel!
    @IBOutlet weak var desiginTypeLabel: UILabel!
    @IBOutlet weak var waybillTypeDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var dealTimeLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var waybillNoLabel: UILabel!
    @IBOutlet weak var twoHandleButton_1: UIButton!
    @IBOutlet weak var twoHandleButton_2: UIButton!
    @IBOutlet weak var oneHandleButton: UIButton!
    @IBOutlet weak var twoHandleView: UIView!
    @IBOutlet weak var oneHandleView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var waybillInfo:WayBillInfoBean?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func twoHandle_first_action(_ sender: Any) {
        // 未配载的情况下
        if self.currentStatus == .unassemble { // 拒绝
            self.rejectWaybill(param: self)
        }
        // 未完成的情况
        if self.currentStatus == .doing {   // 取消运输
            self.toCancelTransformWaybill(param: self)
        }
    }
    
    @IBAction func twoHandle_second_action(_ sender: Any) {
        // 未配载的情况
        if self.currentStatus == .unassemble { // 接受
            self.receiveWaybill(param: self)
        }
        // 未完成的情况
        if self.currentStatus == .doing {   // 继续运输
            self.toContinueTransformWaybill(param: self)
        }
    }
    
    @IBAction func oneHandleAction(_ sender: Any) {
        if self.currentStatus == .unassemble { // 未配载的情况
            if self.waybillInfo?.comeType ==  4 { // 指派
                self.toDesignateWaybill(param: self)
            }
            if self.waybillInfo?.comeType == 1 || self.waybillInfo?.comeType == 2 || self.waybillInfo?.comeType == 3 {
                self.toAssembleWaybill(param: self)
            }
        }
        if self.currentStatus == .doing {
            if self.waybillInfo?.driverStatus == 6 { // 已违约的情况
                self.toAssembleWaybill(param: self)
            }
        }
    }
    
}


extension WaybillCarrierInfoCell {
  
    //设置cell的值
    func contentInfo(info:WayBillInfoBean?, currentBtnIndex: Int) {
        self.waybillInfo = info
        //顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,(运单的分类是以下四种，判断该字段展示相应的cell)
        self.currentStatus = CurrentStatus(rawValue: currentBtnIndex) ?? .unassemble
        
        switch currentBtnIndex {
        case 1:
            //1：未配载
            //info.comeType
            //4种类型判断展示 comeType: 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= 个人指派（按照rp顺序）,
            //driverStatus : Int? // (integer): 当前司机是否接受过改订单  4=接受，接受指派隐藏按钮，否则为没有进行过任何操作，显示两个按钮
            if info?.driverStatus == 4 {
                self.showInfoWillDesigned(info: info)
            } else {
                self.showInfoAcceptAndReject(info: info)
            }
        case 2:
            //2：未完成 依次判断 comeType 运单来源，
            //transportStatus 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派 ,
            //driverStatus 可用于判断违约状态 6=已违约 7=违约继续承运 8=违约放弃承运  ,
            print("未完成")
            setDataWhenUnFinished(info:info)
        case 3:
            //3：完成 依次判断 comeType 运单来源， evaluateCode 不为空，表示承运人已经评价 ,
            print("完成")
        default:
            print("未知")
        }
    }
    
    
    
    //2.未完成的逻辑处理
    func setDataWhenUnFinished(info:WayBillInfoBean?) {
        if info?.transportStatus == 0{//0 待办单
            if info?.driverStatus == 6 {//已违约
                //判断当前承运人的角色 var role  : Int? //承运人角色，1：承运人， 2，司机
                if info?.role == 2 {//司机
                    //当前是承运人角色是司机状态可修改配载时间(显示取消运输，继续运输两个按钮)
                    //在点击继续运输修改时间需要判断orderAvailabilityPeriod 货源有效期这个字段
                    self.showInfoDoingDriverBreakContract(info: info)
                }else{
                    //承运人（显示配载)
                    self.showInfoDoingBreakContract(info: info)
                }
            }else{
                //没违约
                self.showInfoDoingNormal(info: info)
            }
        }
    }
}

//MARK: - Normal display
extension WaybillCarrierInfoCell {
    // 通用的信息展示
    fileprivate func showInfo(info:WayBillInfoBean?) {
        self.waybillInfo = info
        self.configStatus(status: (info?.transportStatus)!, statusLabel: self.statusLabel ,comment: info?.evaluateCode)
        self.toShowWaybillStatusSign(status: (info?.transportStatus)!, for: self.statusImageView)
        self.showFirstLineInfo(info: info, tyLabel: desiginNameLabel, middleLabel: desiginTypeLabel, lastLabel: waybillTypeDescLabel)
        self.startLabel.text = info?.origin
        self.endLabel.text = info?.destination
        self.goodsInfoLabel.text = Util.contact(strs: [Util.dateFormatter(date: (Double(info?.loadingTime ?? "0") ?? 0) / 1000, formatter: "yyyy-MM-dd") , "装货" , info?.goodsName ?? ""], seperate: "    ")
        self.loadTimeLabel.text = Util.dateFormatter(date: Double(info?.loadingTime ?? "0") ?? 0, formatter: "yyyy-MM-dd HH:mm:ss")
        let weight = (info?.goodsWeight ?? "") + "吨"
        self.truckInfoLabel.text = Util.contact(strs: [weight , info?.vehicleLength ?? "" , info?.vehicleWidth ?? "" , info?.goodsType ?? ""], seperate: " | ")
        self.unitPriceLabel.text = String(info?.refercneceUnitPrice ?? 0) + "元"
        self.totalPriceLabel.text = String(info?.refercneceTotalPrice ?? 0) + "元"
        self.waybillNoLabel.text = info?.transportNo
        self.dealTimeLabel.text = Util.dateFormatter(date: info?.createTime ?? 0 , formatter: "yyyy-MM-dd HH:mm:ss")
    }
    
}

//MARK: - 未配载订单对应的显示
extension WaybillCarrierInfoCell {
    // 待配载的显示
    func showInfoWillAssemble(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = true
        self.oneHandleView.isHidden = false
        self.oneHandleButton.setTitle("配载", for: .normal)
    }
    
    // 待指派的显示
    func showInfoWillDesigned(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = true
        self.oneHandleView.isHidden = false
        self.oneHandleButton.setTitle("指派", for: .normal)
    }
    
    // 待接受与拒绝的显示
    func showInfoAcceptAndReject(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = false
        self.oneHandleView.isHidden = true
        self.twoHandleButton_1.setTitle("拒绝", for: .normal)
        self.twoHandleButton_2.setTitle("接受", for: .normal)
    }
}


//MARK: - 未完成订单对应的显示
extension WaybillCarrierInfoCell {
    // 显示已违约司机的显示 -- 待办单
    func showInfoDoingDriverBreakContract(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = false
        self.oneHandleView.isHidden = true
        self.twoHandleButton_1.setTitle("取消运输", for: .normal)
        self.twoHandleButton_2.setTitle("继续运输", for: .normal)
    }
    
    // 显示已违约承运人的显示 -- 待办单
    func showInfoDoingBreakContract(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = true
        self.oneHandleView.isHidden = false
        self.oneHandleButton.setTitle("修改配载", for: .normal)
    }
    
    // 显示未违约的显示 -- 待办单
    func showInfoDoingNormal(info:WayBillInfoBean?) -> Void {
        self.showInfo(info: info)
        self.twoHandleView.isHidden = false
        self.oneHandleView.isHidden = true
        self.twoHandleButton_1.setTitle("取消运输", for: .normal)
        self.twoHandleButton_2.setTitle("继续运输", for: .normal)
    }
}


