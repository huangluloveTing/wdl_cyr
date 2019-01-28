//
//  WaybillAssembleBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import HandyJSON

enum WayBillSourceTypeMode : Int  {
    case driverAssemble  = 1    // 司机配载 对应 运单来源 为 1
    case carrierAssemble  = 2   // 承运人配载 对应 运单 来源 为 2
    case planAssemble   = 3     // 运输计划配载 对应运单来源 为 3
    case designate  = 4         // 指派 对应 运单来源为 4
}

struct WaybillAssembleCommitModel : HandyJSON {
    var carrierId : String? // (string): 承运人ID ,
    var carrierName : String? // (string): 承运人姓名 ,
    var driverId : String? // (string): 司机ID ,
    var driverName : String? // (string): 司机姓名 ,
    var loadWeight : Float? // (number): 载重 ,
    var opType : String? // (string, optional),
    var ordNo : String? // (string): 订单号 ,
    var transportNo : String? // (string): 运单ID ,
    var vehicleNo : String? // (string): 车牌号
    var id:String?
}

struct WaybillAssembleUIModel {
    var commitModel:WaybillAssembleCommitModel = WaybillAssembleCommitModel()
    var driverName : String?
    var vehicleNo:String?
    var unit:Float?
    var total:Float?
    var carrierNum:Float?   // 承运数量
    var disVolumn:Float?    // 分配吨数 --- u运输计划
    var remainNum:Float?    // 剩余分配数量
    var lastRemain:Float?   // 上次分配剩余的数量
}


class WaybillAssembleBaseVC: NormalBaseVC {
    
    private var currentTableView:UITableView?
    
    public var currentDisplayMode : WayBillSourceTypeMode = .driverAssemble
    
    private var currentAssembleModels:[WaybillAssembleUIModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Override
    func toChooseDriver(indexPath:IndexPath) -> Void {} // 选择司机
    func toChooseVehicle(indexPath:IndexPath) -> Void {} // 选择车辆
    func deleteAssemble(section:Int) -> Void {}       // 删除操作
    func inputAssembleWeight(indexPath:IndexPath , input:String) -> Void {} // 输入配载数量
    func commitAssemble() -> Void {}
}

//MARK: - config tableView
extension WaybillAssembleBaseVC {
    
    func configTableView(tableView:UITableView) -> Void {
        currentTableView = tableView
        currentTableView?.delegate = self
        currentTableView?.dataSource = self
        currentTableView?.backgroundColor = UIColor(hex: "eeeeee")
        currentTableView?.separatorStyle = .none
        currentTableView?.separatorColor = UIColor(hex: "DDDDDD")
        currentTableView?.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30)
        currentTableView?.registerCell(className: UITableViewCell.self)
        currentTableView?.registerCell(nib: WaybillAssembleContentCell.self)
        currentTableView?.registerCell(nib: WaybillInputAssembleAmountCell.self)
        currentTableView?.registerCell(nib: WaybillMultiRemailInfoCell.self)
    }
    
    func update(indexPath:IndexPath , model:WaybillAssembleUIModel? , refresh:Bool = false) -> Void {
        if model != nil {
            self.currentAssembleModels[indexPath.section] = model!
        }
        if refresh == true {
            self.currentTableView?.reloadData()
        }
    }
    
    func configUIModel(models:[WaybillAssembleUIModel]) -> Void {
        self.currentAssembleModels = models
        self.currentTableView?.reloadData()
    }
    
    // 更新剩余未配载的数据
    func updateMultiRemain(section:Int) -> Void {
        let indexPath = IndexPath(row: 3, section: section)
        if ((self.currentTableView?.cellForRow(at: indexPath)) != nil) {
            self.currentTableView?.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // 删除
    func deleteAssembledAssembles(section:Int) -> Void {
        self.currentAssembleModels.remove(at: section)
        self.currentTableView?.reloadData()
    }
}

//MARK: - UITableViewDelegate / UITableViewDataSource
extension WaybillAssembleBaseVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            return singleAssembleSection()
        default:
            return multAssembleSections()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            return singleAssembleRows(section: section)
        default:
            return multAssemRows(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentDisplayMode {
        case .driverAssemble:
            return singleAssembleForDriverCells(tableView:tableView ,indexPath:indexPath)
        case .carrierAssemble:
            return singleAssembleForCarrierCells(tableView:tableView , indexPath: indexPath)
        default:
            return multiAssembleCell(indexPath: indexPath, tableView: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.currentDisplayMode == .planAssemble {
            return multiAssembleHeader(section: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.currentDisplayMode == .planAssemble {
            return 60
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assembleSelect(tableView: tableView, indexPath: indexPath)
    }
}

extension WaybillAssembleBaseVC {
    
    //MARK: - 当前展示 数据
    public func currentAssembleData() -> [WaybillAssembleUIModel] {
        return self.currentAssembleModels
    }
}


//MARK: - normal
extension WaybillAssembleBaseVC {
    //MARK: - 配载 单车配载 -- 驾驶员
    func singleAssembleForDriverCells(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillAssembleContentCell.self)
        let row = indexPath.row
        cell.accessoryType = .none
        let info = currentAssembleModels[indexPath.section]
        if row == 0 {
            cell.showInfo(title: "驾驶员", content: info.driverName, hight: true)
        }
        if row == 1 {
            cell.showInfo(title: "车牌号", content: info.vehicleNo, hight: true)
            cell.accessoryType = .disclosureIndicator
        }
        if row == 2 {
            cell.showInfo(title: "报价", content: Util.floatPoint(num: 2, floatValue: info.unit ?? 0), hight: false)
        }
        if row == 3 {
            cell.showInfo(title: "总价", content: Util.floatPoint(num: 2, floatValue: info.total ?? 0), hight: false)
        }
        if row == 4 {
            cell.showInfo(title: "承运数量", content: Util.floatPoint(num: 0, floatValue: info.carrierNum ?? 0), hight: false)
        }
        return cell
    }
    
    //MARK: - 配载 单车配载 -- 承运人
    func singleAssembleForCarrierCells(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillAssembleContentCell.self)
        let row = indexPath.row
        cell.accessoryType = .none
        let info = currentAssembleModels[indexPath.section]
        if row == 0 {
            cell.accessoryType = .disclosureIndicator
            cell.showInfo(title: "驾驶员", content: info.driverName, hight: true)
        }
        if row == 1 {
            cell.showInfo(title: "车牌号", content: info.vehicleNo, hight: true)
            cell.accessoryType = .disclosureIndicator
        }
        if row == 2 {
            cell.showInfo(title: "报价", content: Util.floatPoint(num: 2, floatValue: info.unit ?? 0), hight: false)
        }
        if row == 3 {
            cell.showInfo(title: "总价", content: Util.floatPoint(num: 2, floatValue: info.total ?? 0), hight: false)
        }
        if row == 4 {
            cell.showInfo(title: "承运数量", content: Util.floatPoint(num: 0, floatValue: info.carrierNum ?? 0), hight: false)
        }
        return cell
    }
    
    func singleAssembleSection() -> Int {
        return 1
    }
    
    func singleAssembleRows(section:Int) -> Int {
        return 5
    }
    
    func singleHeader() -> UIView? {
        return nil
    }
    
    func assembleSelect(tableView:UITableView , indexPath:IndexPath) -> Void {
        if self.currentDisplayMode == .driverAssemble {
            if indexPath.row == 1 {
                self.toChooseVehicle(indexPath: indexPath)
            }
        }
        if self.currentDisplayMode == .carrierAssemble {
            if indexPath.row == 0 {
                self.toChooseDriver(indexPath: indexPath)
            }
            if indexPath.row == 1 {
                self.toChooseVehicle(indexPath: indexPath)
            }
        }
        if self.currentDisplayMode == .planAssemble {
            if indexPath.row == 0 {
                self.toChooseDriver(indexPath: indexPath)
            }
            if indexPath.row == 1 {
                self.toChooseVehicle(indexPath: indexPath)
            }
        }
    }
}


//MARK: - 多车配载时
extension WaybillAssembleBaseVC {
    func multAssembleSections() -> Int {
        return self.currentAssembleModels.count
    }
    
    func multAssemRows(section:Int) -> Int {
        return 4
    }
    
    func multiAssembleCell(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let info = self.currentAssembleModels[indexPath.section]
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(nib: WaybillAssembleContentCell.self)
            cell.showInfo(title: "驾驶员", content: info.driverName, hight: true)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if row == 1 {
            let cell = tableView.dequeueReusableCell(nib: WaybillAssembleContentCell.self)
            cell.showInfo(title: "车牌号", content: info.vehicleNo, hight: true)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if row == 2 {
            let cell = tableView.dequeueReusableCell(nib: WaybillInputAssembleAmountCell.self)
            cell.showInfo(num: info.disVolumn, canEdit: indexPath.section == (currentAssembleData().count - 1))
            cell.inputClosure = { [weak self] (text) in
                self?.inputAssembleWeight(indexPath: indexPath, input: text)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(nib: WaybillMultiRemailInfoCell.self)
        cell.showInfo(total: info.carrierNum, remain: info.remainNum)
        return cell
    }
    
    func multiAssembleHeader(section:Int) -> UIView? {
        let title = "车辆信息(" + String(section) + ")"
        let show = section > 0
        let header = WaybillAssembleHeader.instance(title: title, showDelete: show)
        header?.deleteClosure = {[weak self] in
            self?.deleteAssemble(section: section)
        }
        return header
    }
}


