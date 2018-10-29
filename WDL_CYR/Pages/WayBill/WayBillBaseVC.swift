//
//  WayBillBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillBaseVC: MainBaseVC {
    
    public var currentTableView:UITableView!
    
    // 状态下拉视图
    var statusView : GoodsSupplyStatusDropView?
    var timeChooseView : DropInputDateView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Handles
extension WayBillBaseVC {
    
    //MARK: - Handles
    func toRejectWaybill<T>(param:T) -> Void {
        
    }
    
    func toReceiveWaybill<T>(param:T) -> Void {
        
    }
    
    func toDesiginWaybill<T>(param:T) -> Void {
        
    }
    
    func toAssembleWaybill<T>(param:T) -> Void {
        
    }
}

// 筛选下拉视图
extension WayBillBaseVC : DropHintViewDataSource {
    
    func toConfigDropView(dropView:DropHintView) -> Void {
        dropView.dataSource = self
        dropView.tabTitles(titles: ["报价时间","报价状态"])
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        if index == 0 {
            if self.timeChooseView == nil {
                self.timeChooseView = DropInputDateView.instanceDateView()
            }
            return timeChooseView!
        } else {
            if self.statusView == nil {
                self.statusView = statusDropViewGenerate(statusTitles: GoodsStatus)
            }
            return self.statusView!
        }
    }
}

//MARK: cells
extension WayBillBaseVC {
    
    // 注册cell
    func registerAllCells(for tableView:UITableView) -> Void {
        self.registerCell(nibName: "\(WaybillCarrierInfoCell.self)", for: tableView)
        self.registerCell(nibName: "\(WaybillSepecialInfoCell.self)", for: tableView)
    }
    
    /// 未配载
    /// - 1、 由其他承运人成交后指派给你的运单信息（作为驾驶员情况，不可转）
    /// - 2、 由TMS指定承运人，信息会同步到运单中（作为承运人，接受后可转给自己的驾驶员或者自己承运）
    /// - 3、 特殊环节：由TMS指定承运人后发起运输计划，会显示在该栏目里面该条信息暂时没有（会有SAP订单号运单号（此时还未生成订单）承运人接受后，配载车辆和驾驶员信息+吨位分配，反馈到TMS，TMS配置好单车所装货物，WDL生成单个或多个运单（根据配载车辆而定，一车一个订单）。转入1或2
    /// - 4、 由TMS获取代办货源信息，信息会放在无敌拉平台，承运人无车报价后自动成交，成交成功后在承运人端显示该条运单信息。可转由五得利周边第三方由托运人发布（自动或手动成交）货源信息，由承运人竞价成功后显示
    /// 未接受
}

