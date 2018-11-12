//
//  WaybillAssembleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

enum WaybillAssembleMode {
    case singleAssemble // 单车配载
    case multiAssemble  // 多车配载
}

class WaybillAssembleVC: WaybillAssembleBaseVC {
    
    public var changeAssemble:Bool = false  // 是否是修改配载，目前只针对单车配载的e情况

    @IBOutlet weak var tableView: UITableView!
    
    public var pageInfo:TransactionInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView(tableView: tableView)
        self.configToDisplay()
    }
}

extension WaybillAssembleVC {
    //MARK: - 根据传入的数据，配置数据展示
    private func configToDisplay() -> Void {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            configSingleAssembleDisplay()
            
        default:
            self.configMultiAssembleDisplay()
        }
    }
    
    //MARK: - 配置司机配载和承运人配载
    func configSingleAssembleDisplay() -> Void {
        var model = WaybillAssembleUIModel()
        model.driverName = pageInfo?.dirverName
        model.vehicleNo = pageInfo?.vehicleNo
        model.unit = Float(pageInfo?.dealUnitPrice ?? 0)
        model.total = Float(pageInfo?.dealTotalPrice ?? 0)
        model.carrierNum = pageInfo?.goodsWeight
        self.configUIModel(models: [model])
    }
    
    //MARK: - 配置 运输计划的配载展示
    func configMultiAssembleDisplay() -> Void {
        var model = WaybillAssembleUIModel()
        model.driverName = pageInfo?.dirverName
        model.vehicleNo = pageInfo?.vehicleNo
        model.unit = Float(pageInfo?.dealUnitPrice ?? 0)
        model.total = Float(pageInfo?.dealTotalPrice ?? 0)
        model.carrierNum = pageInfo?.goodsWeight
        self.configUIModel(models: [model])
    }
}
