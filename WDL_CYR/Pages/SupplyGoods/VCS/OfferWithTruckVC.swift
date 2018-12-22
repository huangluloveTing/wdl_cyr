//
//  OfferWithTruckVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

/// 有车报价
class OfferWithTruckVC: CarrierOfferBaseVC {
    
    let titles = ["承运人","驾驶员","车辆","报价","总价","服务费"]
    let units = ["","","","元/吨","元","元"]
    let placeholders = ["","请选择","请选择","请输入","",""]
    
    @IBOutlet weak var tableView: UITableView!
    
    public var resource:ResourceDetailUIModel?
    
    private var offerModel = OfferWithTruckCommitModel() // 报价请求model
    private var carrierInfo : CarrierInfoFee?            // CarrierInfoFee
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDisplayData()
        self.configTableView()
        self.registerAllCells()
        self.loadFee()
    }

}

extension OfferWithTruckVC {
    //MARK: configTableView
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    
    func registerAllCells() -> Void{
        self.tableView.registerCell(nib: OfferInputCell.self)
        self.tableView.registerCell(nib: OfferFeeCell.self)
        self.tableView.registerCell(nib: CommitCell.self)
    }
    
    func initDisplayData() -> Void {
        self.offerModel.carrierName = self.resource?.resource?.carrierName ?? ""
    }
    
    //MARK: - 获取报价信息
    func loadFee() -> Void {
        let hallId = self.resource?.resource?.id ?? ""
        self.showLoading()
        self.loadCarrierInfo(hallId: hallId) { [weak self](info, error) in
            if let error = error {
                self?.showFail(fail: error.localizedDescription, complete: {
                    self?.pop()
                })
                return
            }
            self?.hiddenToast()
            self?.carrierInfo = info
            self?.configNetToUI()
            self?.tableView.reloadData()
        }
    }
    
    // 将获取的数据信息配置到显示界面上
    func configNetToUI() -> Void {
        self.offerModel.carrierName = self.carrierInfo?.carrierName ?? ""
        self.offerModel.myBalance = self.carrierInfo?.useableMoney ?? 0
        self.offerModel.serviceFee = self.carrierInfo?.singleTimeFee ?? 0
    }
}

extension OfferWithTruckVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 1 {
            self.toChooseDriver()
        }
        if row == 2 {
            self.toChooseTruck()
        }
    }
}

extension OfferWithTruckVC {
    // 驾驶员选择
    func toChooseDriver() -> Void {
        let driverChooseVC = OfferChooseDriverVC()
        driverChooseVC.searchResultClosure = { [weak self] (capacity) in
            var driver = OfferWithTruckDriverModel()
            driver.driverName = capacity.driverName
            driver.idCard = capacity.driverId
            driver.phone = capacity.driverPhone
            driver.type = capacity.capacityType
            driver.driverId = capacity.driverId
            self?.offerModel.driverModel = driver
            self?.tableView.reloadData()
        }
        self.pushToVC(vc: driverChooseVC, title: "承运人")
    }
    
    // 车辆选择
    func toChooseTruck() -> Void {
        let truckVC = OfferChooseTruckVC()
        truckVC.searchResultClosure = {[weak self] (capacity) in
            var truck = OfferWithTruckModel()
            truck.truckLength = capacity.vehicleLength
            truck.truckNo = capacity.vehicleNo
            truck.truckType = capacity.vehicleType
            truck.truckWeight = capacity.vehicleWeight
            self?.offerModel.truckModel = truck
            self?.tableView.reloadData()
        }
        self.pushToVC(vc: truckVC, title: "选择车辆")
    }
    
    // 将获取到的费用信息展示到UI上
    func toRefresh() -> Void {
        self.offerModel.serviceFee = self.carrierInfo?.singleTimeFee ?? 0
        self.offerModel.myBalance = self.carrierInfo?.useableMoney ?? 0
        self.tableView.reloadData()
    }
    
    // 根据填写的单价，计算总价，并反馈到UI上
    func toCaculateTotal(unit:Float) -> Void {
        let weight = self.resource?.resource?.goodsWeight
        let total = (weight ?? 0) * unit
        self.offerModel.total = total
        self.offerModel.offerUnitPrice = unit
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
    }
    
    // 提交报价
    func commitOffer() -> Void {
        if !canCommitOffer() {
            return
        }
        var commit = CarrierOfferCommitModel()
        commit.driverName = offerModel.driverModel?.driverName
        commit.driverPhone = offerModel.driverModel?.phone
        commit.driverId = offerModel.driverModel?.driverId
        commit.carrierType = 1
        commit.vehicleNo = offerModel.truckModel?.truckNo
        commit.hallId = self.resource?.resource?.id
        commit.quotedPrice = offerModel.offerUnitPrice
        commit.totalPrice = offerModel.total
        commit.loadWeight = self.resource?.resource?.goodsWeight
        commit.infoFee = self.carrierInfo?.singleTimeFee
        self.showLoading(title: "正在提交", complete: nil)
        BaseApi.request(target: API.addOffer(commit), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    if let callBack = self?.callBack {
                        var newResource = self?.resource?.resource
                        newResource?.isOffer = "OK"
                        callBack(.refresh(newResource))
                    }
//                    self?.popCurrent(beforeIndes: 2, animation: true)
                    self?.pop(toRootViewControllerAnimation: true
                    )
                })
            }, onError: { [weak self](error) in
                
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    func canCommitOffer() -> Bool {
        if offerModel.driverModel == nil {
            self.showWarn(warn: "请选择驾驶员", complete: nil)
            return false
        }
        if offerModel.truckModel == nil {
            self.showWarn(warn: "请选择车辆", complete: nil)
            return false
        }
        if offerModel.offerUnitPrice == nil || (offerModel.offerUnitPrice ?? 0) <= 0 {
            self.showWarn(warn: "请填写正确的报价", complete: nil)
            return false
        }
        return true
    }
}


extension OfferWithTruckVC {
    
    // 根据业务，配置cell
    func currentCell(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .showContent
            
            cell.showInfo(title: titles[row], content: offerModel.carrierName, unit: units[row], placeholder: placeholders[row])
//            cell.showInfo(title: titles[row], content: self.carrierInfo?.carrierName, unit: units[row], placeholder: placeholders[row])
            
            return cell
        }
        if row == 1 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .indicatorInput
            cell.showInfo(title: titles[row], content: offerModel.driverModel?.driverName, unit: units[row], placeholder: placeholders[row] , style: .indicatorInput)
            return cell
        }
        
        if row == 2 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .indicatorInput
            cell.showInfo(title: titles[row], content: offerModel.truckModel?.truckNo, unit: units[row], placeholder: placeholders[row] , style: .indicatorInput)
            return cell
        }
        
        if row == 3 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .input
            let total = offerModel.total == 0 ? "" : String(offerModel.total)
            cell.showInfo(title: titles[row], content: total, unit: units[row], placeholder: placeholders[row] , style: .input)
            cell.keyboardType = UIKeyboardType.decimalPad
            cell.inputClosure = {[weak self](text) in
                let price = Float(text)
                self?.toCaculateTotal(unit: price ?? 0)
            }
            return cell
        }
        
        if row == 4 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .showContent
            cell.showInfo(title: titles[row], content: String(offerModel.total), unit: units[row], placeholder: placeholders[row])
            return cell
        }
        
        if row == 5 {
            let cell = tableView.dequeueReusableCell(nib: OfferFeeCell.self)
            cell.showFee(serviceFee: offerModel.serviceFee, balance: offerModel.myBalance)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(nib: CommitCell.self)
        cell.commitClosure = {[weak self] in
            self?.commitOffer()
        }
        return cell
    }
}

