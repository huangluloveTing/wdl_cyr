//
//  ResourceDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ResourceDetailVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 从上个页面 传 托运人信息，以及货源信息
    public var resource:ResourceDetailUIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubViews()
        self.registerAllCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bottomButtom(titles: ["我要报价"], targetView: self.tableView) { [weak self](_) in
            self?.toReportPrice()
        }
    }
    
    //MARK: route
    override func routeName(routeName: String, dataInfo: Any?) {
        if routeName == "\(Resource_GoodsInfoCell.self)" {
            self.toFocusLine() // 关注线路
        }
        if routeName == "\(Resource_ShipperInfoCell.self)" {
            self.toFocusCarrier() // 关注托运人
        }
    }
}

extension ResourceDetailVC {
    //MARK: configTableView
    func configSubViews() -> Void {
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.tableView.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func registerAllCells() -> Void {
        self.registerForNibCell(className: Resource_PriceInfoCell.self, for: tableView)
        self.registerForNibCell(className: Resource_GoodsInfoCell.self, for: tableView)
        self.registerForNibCell(className: Resource_ShipperInfoCell.self, for: tableView)
    }
}

//MARK: Handles
extension ResourceDetailVC {
    
    // 去报价
    func toReportPrice() -> Void {
        self.toChooseOfferType(resource: self.resource)
    }
    
    // 关注线路
    func toFocusLine() -> Void {
        let startProvince = self.resource?.resource?.startProvince ?? ""
        let startCity = self.resource?.resource?.startCity ?? ""
        let endProvince = self.resource?.resource?.endProvince ?? ""
        let endCity = self.resource?.resource?.endCity ?? ""
        self.showLoading(title: "", canInterface: true)
        BaseApi.request(target: API.addFollowLine(startProvince, startCity, endProvince, endCity), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: nil)
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    // 关注托运人
    func toFocusCarrier() -> Void {
        var query = AddShipperQueryModel()
        query.shipperId = self.resource?.resource?.consignorNo ?? ""
        query.shipperType = self.resource?.resource?.consignorType ?? ""
        self.showLoading(title: "", canInterface: true)
        BaseApi.request(target: API.addFollowShipper(query), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: nil)
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}

extension ResourceDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = self.dequeueReusableCell(className: Resource_PriceInfoCell.self, for: tableView)
            cell.showInfo(unit: self.resource?.refercneceUnitPrice, total: self.resource?.refercneceTotalPrice)
            return cell
        }
        
        if section == 1 {
            let cell = self.dequeueReusableCell(className: Resource_GoodsInfoCell.self, for: tableView)
            let start = (self.resource?.resource?.startProvince ?? "") + (self.resource?.resource?.startCity ?? "")
            let end = (self.resource?.resource?.endProvince ?? "") + (self.resource?.resource?.endCity ?? "")
            let loadTime = self.resource?.resource?.loadingTime ?? 0
            let goodsName = self.resource?.resource?.goodsName
            let goodsType = self.resource?.resource?.goodsType
            let remark = self.resource?.resource?.remark ?? " "
//            let summary = Util.contact(strs: [<#T##[String]#>], seperate: <#T##String#>)
            cell.showInfo(start: start,
                          end: end,
                          loadTime: loadTime,
                          goodsName: goodsName,
                          goodsType: goodsType,
                          goodsSumm: "",
                          remark: remark)
            return cell
        }
        
        let cell = self.dequeueReusableCell(className: Resource_ShipperInfoCell.self, for: tableView)
        cell.showInfo(name: self.resource?.carrierName,
                      dealNum: self.resource?.dealCount ?? 0,
                      rate: self.resource?.rate ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
