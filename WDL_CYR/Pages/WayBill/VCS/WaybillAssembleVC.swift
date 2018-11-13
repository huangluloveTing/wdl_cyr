//
//  WaybillAssembleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillAssembleVC: WaybillAssembleBaseVC {
    
    public var changeAssemble:Bool = false  // 是否是修改配载，目前只针对单车配载的e情况

    @IBOutlet weak var tableView: UITableView!
    
    public var pageInfo:TransactionInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView(tableView: tableView)
        self.configToDisplay()
    }
    
    override func zt_rightBarButtonAction(_ sender: UIBarButtonItem!) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configBottom()
    }
    
//    func inputAssembleWeight(indexPath:IndexPath , input:String) -> Void {} // 输入配载数量
    override func inputAssembleWeight(indexPath: IndexPath, input: String) {
        let assembles = currentAssembleData()
        var inputAssemble:WaybillAssembleUIModel? = nil
        if indexPath.row < assembles.count {
            inputAssemble = assembles[indexPath.row]
        }
        inputAssemble?.commitModel.loadWeight = Float(input) ?? 0
        update(indexPath: indexPath, model: inputAssemble!)
    }
}

extension WaybillAssembleVC {
    //MARK: - 根据传入的数据，配置数据展示
    private func configToDisplay() -> Void {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            configSingleAssembleDisplay()
            break;
        default:
            self.addRightBarbuttonItem(withTitle: "添加车辆")
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
        model.remainNum = model.carrierNum
        self.configUIModel(models: [model])
    }
    
    //MARK: - 添加车辆
    func toAddVehicle() -> Void {
        var assembles = self.currentAssembleData()
        var total:Float = 0
        for assemble  in assembles {
            if assemble.disVolumn == nil || assemble.disVolumn == 0 {
                self.showWarn(warn: "请完善配载情况再添加车辆", complete: nil)
                return
            }
            total += (assemble.disVolumn ?? 0)
        }
        let remainNum = (pageInfo?.goodsWeight ?? 0) - total
        var newAssemble = WaybillAssembleUIModel()
        newAssemble.driverName = pageInfo?.dirverName
        newAssemble.vehicleNo = pageInfo?.vehicleNo
        newAssemble.unit = Float(pageInfo?.dealUnitPrice ?? 0)
        newAssemble.total = Float(pageInfo?.dealTotalPrice ?? 0)
        newAssemble.carrierNum = remainNum
        newAssemble.remainNum = remainNum
        assembles.append(newAssemble)
        self.configUIModel(models: assembles)
    }
    
    //MARK： - bottom
    func configBottom() -> Void {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            self.bottomButtom(titles:  ["提交"], targetView: self.tableView) { (index) in
                
            }
            break
        default:
            self.bottomButtom(titles: ["申请配载"], targetView: self.tableView) { (index) in
                
            }
        }
    }
    //
}
