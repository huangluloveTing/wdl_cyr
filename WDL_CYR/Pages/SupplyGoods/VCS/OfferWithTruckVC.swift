//
//  OfferWithTruckVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

let titles = ["承运人","驾驶员","车辆","报价","总价","服务费"]
let units = ["","","","元/吨","元","元"]
let placeholders = ["","请选择","请选择","请输入","",""]
/// 有车报价
class OfferWithTruckVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var resource:ResourceDetailUIModel?
    
    private var offerModel = OfferWithTruckCommitModel() // 报价请求model
    private var carrierInfo : CarrierInfoFee?            // CarrierInfoFee
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDisplayData()
        self.configTableView()
        self.registerAllCells()
        self.loadCarrierInfo()
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
        self.offerModel.carrierName = self.resource?.resource?.consignorName ?? ""
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
    }
}

extension OfferWithTruckVC {
    // 驾驶员选择
    func toChooseDriver() -> Void {
        let driverChooseVC = OfferChooseDriverVC()
        self.push(vc: driverChooseVC, title: "承运人")
    }
    
    // 将获取到的费用信息展示到UI上
    func toRefresh() -> Void {
        self.offerModel.serviceFee = self.carrierInfo?.singleTimeFee ?? 0
        self.offerModel.myBalance = self.carrierInfo?.useableMoney ?? 0
        self.tableView.reloadData()
    }
    
    // 获取 报价时，获取承运人保证金、服务费等信息
    func loadCarrierInfo() -> Void {
        let hallId = self.resource?.resource?.id ?? ""
        BaseApi.request(target: API.findCarrierInfoFee(hallId), type: BaseResponseModel<CarrierInfoFee>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.carrierInfo = data.data
                self?.toRefresh()
            }, onError: { (error) in
                
            })
            .disposed(by: dispose)
    }
    
    // 根据填写的单价，计算总价，并反馈到UI上
    func toCaculateTotal(unit:Float) -> Void {
        let weight = self.resource?.resource?.goodsWeight
        let total = (weight ?? 0) * unit
        self.offerModel.total = total
        self.offerModel.offerUnitPrice = unit
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
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
            let total = String(offerModel.total)
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
        return cell
    }
}

