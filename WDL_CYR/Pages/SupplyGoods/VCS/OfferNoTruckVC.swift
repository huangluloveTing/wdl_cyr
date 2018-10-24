//
//  OfferNoTruckVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/23.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class OfferNoTruckVC: NormalBaseVC {
    
    let titles = ["承运人","报价","总价","服务费"]
    let units = ["","元/吨","元","元"]
    let placeholders = ["","请输入","",""]
    
    @IBOutlet weak var tableView: UITableView!
    
    public var resource:ResourceDetailUIModel?
    
    private var offerModel = OfferWithTruckCommitModel() // 报价请求model
    private var carrierInfo : CarrierInfoFee?            // CarrierInfoFee
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.registerAllCells()
        self.initDisplayData()
    }

}


extension OfferNoTruckVC {
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
        self.tableView.registerCell(nib: OfferDescriptionCell.self)
    }
    
    func initDisplayData() -> Void {
        self.offerModel.carrierName = self.resource?.resource?.consignorName ?? ""
    }
}

// Handles
extension OfferNoTruckVC {
    
    // 计算总价
    func toCaculateTotalPrice(unitPrice:Float) -> Void {
        let weight = self.resource?.resource?.goodsWeight
        let total = (weight ?? 0) * unitPrice
        self.offerModel.total = total
        self.offerModel.offerUnitPrice = unitPrice
        self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
    
    // 提交报价
    func commitOffer() -> Void {
        var commit = CarrierOfferCommitModel()
        commit.hallId = self.resource?.resource?.id
        commit.quotedPrice = offerModel.offerUnitPrice
        commit.totalPrice = offerModel.total
        self.showLoading(title: "正在提交", complete: nil)
        BaseApi.request(target: API.addOffer(commit), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop()
                })
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
}

extension OfferNoTruckVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(indexPath: indexPath, tableView: tableView)
    }
}


extension OfferNoTruckVC {
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
            let total = offerModel.total == 0 ? "" : String(offerModel.total)
            cell.showInfo(title: titles[row], content: total, unit: units[row], placeholder: placeholders[row] , style: .input)
            cell.keyboardType = UIKeyboardType.decimalPad
            cell.inputClosure = {[weak self](text) in
                let price = Float(text)
                self?.toCaculateTotalPrice(unitPrice: price ?? 0)
            }
            return cell
        }
        
        if row == 2 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            let total = offerModel.total == 0 ? "" : String(format: "%.2f", offerModel.total)
            cell.showInfo(title: titles[row],
                          content:total ,
                          unit: units[row],
                          placeholder: placeholders[row] ,
                          style: .showContent)
            return cell
        }
        
        if row == 3 {
            let cell = tableView.dequeueReusableCell(nib: OfferFeeCell.self)
            cell.showFee(serviceFee: offerModel.serviceFee, balance: offerModel.myBalance)
            return cell
        }
        
        if row == 4 {
            let cell = tableView.dequeueReusableCell(nib: OfferDescriptionCell.self)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(nib: CommitCell.self)
        cell.commitClosure = {[weak self] in
            self?.commitOffer()
        }
        return cell
    }
}
