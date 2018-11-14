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
        self.toAddVehicle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configBottom()
    }
    
//    func inputAssembleWeight(indexPath:IndexPath , input:String) -> Void {} // 输入配载数量
    override func inputAssembleWeight(indexPath: IndexPath, input: String) {
        if input.count <= 0 {
            return
        }
        let volumn = Float(input) // 输入的分配吨数
        guard let disVolumn = volumn else {
            self.showWarn(warn: "请输入正确的数字", complete: nil)
            return
        }
        let assembles = currentAssembleData()
        var inputAssemble:WaybillAssembleUIModel? = nil
        if indexPath.section < assembles.count {
            inputAssemble = assembles[indexPath.section]
        }
        let lastRemain = inputAssemble?.lastRemain ?? 0
        let remain = lastRemain - disVolumn
        if remain < 0 {
            self.showWarn(warn: "请填写正确的配载数量", complete: nil)
            return
        }
        inputAssemble?.commitModel.loadWeight = disVolumn
        inputAssemble?.disVolumn = disVolumn
        inputAssemble?.remainNum = remain
        update(indexPath: indexPath, model: inputAssemble!)
        updateMultiRemain(section: indexPath.section)
    }
    
    override func toChooseDriver(indexPath: IndexPath) {
        if self.currentDisplayMode == .driverAssemble {
            return
        }
        if self.currentDisplayMode == .carrierAssemble || self.currentDisplayMode == .planAssemble {
            self.toChooseTruck { [weak self](ca) in
                self?.toChooseDriverResultHandle(indexPath: indexPath, capacity: ca)
            }
        }
    }
    
    override func toChooseVehicle(indexPath: IndexPath) {
        self.toChooseTruck {[weak self] (capa) in
            self?.toChooseVehicleResultHandle(indexPath: indexPath, capacity: capa)
        }
    }
    
    // 提交操作
    override func commitAssemble() {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            commitAssembleForSingleVehicle()
            break
        default:
            commitAssembleForMultiVehicle()
        }
    }
    
    override func deleteAssemble(section: Int) {
        self.deleteAssembledAssembles(section: section)
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
        model.commitModel.driverId = pageInfo?.driverId
        model.commitModel.ordNo = pageInfo?.ordNo
        model.commitModel.vehicleNo = pageInfo?.vehicleNo
        model.commitModel.transportNo = pageInfo?.transportNo
        model.commitModel.loadWeight = pageInfo?.goodsWeight
        model.commitModel.driverName = pageInfo?.dirverName
        model.driverName = pageInfo?.dirverName
        model.vehicleNo = pageInfo?.vehicleNo
        model.unit = Float(pageInfo?.dealUnitPrice ?? 0)
        model.total = Float(pageInfo?.dealTotalPrice ?? 0)
        model.carrierNum = pageInfo?.goodsWeight
        model.remainNum = pageInfo?.goodsWeight
        model.lastRemain = pageInfo?.goodsWeight
        self.configUIModel(models: [model])
    }
    
    //MARK: - 配置 运输计划的配载展示
    func configMultiAssembleDisplay() -> Void {
        var model = WaybillAssembleUIModel()
        model.commitModel.driverId = pageInfo?.driverId
        model.commitModel.ordNo = pageInfo?.ordNo
        model.commitModel.vehicleNo = pageInfo?.vehicleNo
        model.commitModel.transportNo = pageInfo?.transportNo
        model.commitModel.loadWeight = pageInfo?.goodsWeight
        model.commitModel.driverName = pageInfo?.dirverName
        model.driverName = pageInfo?.dirverName
        model.vehicleNo = pageInfo?.vehicleNo
        model.unit = Float(pageInfo?.dealUnitPrice ?? 0)
        model.total = Float(pageInfo?.dealTotalPrice ?? 0)
        model.carrierNum = pageInfo?.goodsWeight
        model.remainNum = model.carrierNum
        model.remainNum = pageInfo?.goodsWeight
        model.lastRemain = pageInfo?.goodsWeight
        self.configUIModel(models: [model])
    }
    
    //MARK: - 添加车辆
    func toAddVehicle() -> Void {
        var assembles = self.currentAssembleData()
        var newAssemble = assembles.last
        if (newAssemble?.remainNum ?? 0) <= 0 {
            self.showWarn(warn: "已配载完", complete: nil)
            return
        }
        if (newAssemble?.disVolumn ?? 0) <= 0 || newAssemble?.disVolumn == nil {
            self.showWarn(warn: "请先填写配载数量", complete: nil)
            return
        }
        
        let remain = newAssemble?.remainNum
        newAssemble?.lastRemain = remain
        newAssemble?.disVolumn = nil
        assembles.append(newAssemble!)
        self.configUIModel(models: assembles)
    }
    
    //MARK： - bottom
    func configBottom() -> Void {
        self.tableView.tableFooterView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
            view.backgroundColor = self.tableView.backgroundColor
            return view
        }()
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            self.bottomButtom(titles:  ["提交"], targetView: self.tableView) { (index) in
                self.commitAssemble()
            }
            break
        default:
            self.bottomButtom(titles: ["申请配载"], targetView: self.tableView) { (index) in
                self.commitAssemble()
            }
        }
    }
    
    // 选择对应的驾驶员的操作
    func toChooseDriverResultHandle(indexPath:IndexPath , capacity:ZbnTransportCapacity ) -> Void {
        let driverId = capacity.driverId
        let driverName = capacity.driverName
        var assembles = currentAssembleData()
        var assembel = assembles[indexPath.section]
        assembel.driverName = driverName
        assembel.commitModel.driverId = driverId
        assembel.commitModel.driverName = driverName
        update(indexPath: indexPath, model: assembel, refresh: true)
    }
    
    // 选择对应的车辆的操作
    func toChooseVehicleResultHandle(indexPath:IndexPath , capacity:ZbnTransportCapacity) -> Void {
        let vehicleNo = capacity.vehicleNo
        var assembles = currentAssembleData()
        var assembel = assembles[indexPath.section]
        assembel.vehicleNo = vehicleNo
        assembel.commitModel.vehicleNo = vehicleNo
        update(indexPath: indexPath, model: assembel, refresh: true)
    }
}

extension WaybillAssembleVC {
    
    //MARK: - 提交配载 单车配载
    func commitAssembleForSingleVehicle() -> Void {
        let assemble = currentAssembleData().first
        if assemble?.commitModel.driverId == nil || assemble?.commitModel.driverId?.count == 0 {
            self.showFail(fail: "请选择司机", complete: nil)
            return
        }
        if assemble?.commitModel.vehicleNo == nil || assemble?.commitModel.vehicleNo?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showFail(fail: "请选择车辆", complete: nil)
            return
        }
        self.showLoading()
        BaseApi.request(target: API.assembleWaybill((assemble?.commitModel)!), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop()
                })
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 提交配载 多车配载
    func commitAssembleForMultiVehicle() -> Void {
        let assembles = currentAssembleData()
        var commitModels = [WaybillAssembleCommitModel]()
        for assemble in assembles {
            if assemble.commitModel.driverId == nil || assemble.commitModel.driverId?.count == 0 {
                self.showWarn(warn: "请完善司机信息", complete: nil)
                return;
            }
            if assemble.commitModel.vehicleNo == nil || assemble.commitModel.vehicleNo?.trimmingCharacters(in: .whitespaces).count == 0 {
                self.showWarn(warn: "请选择车辆", complete: nil)
                return
            }
            if assemble.carrierNum == 0 {
                self.showWarn(warn: "请完善分配吨数", complete: nil)
                return;
            }
            if (assemble.carrierNum ?? 0) > (assemble.lastRemain ?? 0) {
                self.showWarn(warn: "请检查分配数量填写是否正确", complete: nil)
            }
            commitModels.append(assemble.commitModel)
        }
        self.showLoading()
        BaseApi.request(target: API.assemblePlanWaybill(commitModels), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop()
                })
                }, onError: { (error) in
                    self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}

