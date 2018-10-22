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
    
    private var offerModel = OfferWithTruckCommitModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.registerAllCells()
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
}

extension OfferWithTruckVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
            cell.showInfo(title: titles[row], content: offerModel.carrierName, unit: units[row], placeholder: placeholders[row] , style: .indicatorInput)
            return cell
        }
        
        if row == 2 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .indicatorInput
            cell.showInfo(title: titles[row], content: offerModel.carrierName, unit: units[row], placeholder: placeholders[row] , style: .indicatorInput)
            return cell
        }
        
        if row == 3 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .input
            cell.showInfo(title: titles[row], content: offerModel.carrierName, unit: units[row], placeholder: placeholders[row] , style: .input)
            return cell
        }
        
        if row == 4 {
            let cell = tableView.dequeueReusableCell(nib: OfferInputCell.self)
            cell.currentStyle = .showContent
            cell.showInfo(title: titles[row], content: offerModel.carrierName, unit: units[row], placeholder: placeholders[row])
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

