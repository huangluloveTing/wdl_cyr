//
//  GSDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetailVC: GSDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var currentStatus:SourceStatus = .other // 判断当前的报价状态
    private var offerLists:[ZbnOfferModel] = []     // 报价数据
    
    
    public var offer:OfferOrderHallResultApp?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.configCurrentHallStatus()
        self.loadOffer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: overrride
    // 取消报价
    override func cancelOffer() -> Void {
        
    }
     // 重新报价
    override func toOfferAgain() -> Void {
        
    }
    
    // 竞标中 竞标中的倒计时
    override func bidding_timer() -> TimeInterval {
        return Double(self.offer?.autoTimeInterval ?? 0) * 3600
    }
    
    // 已驳回 驳回原因
    override func rejectReason() -> String {
        return ""
    }
    
    // 未成交原因
    override func notDealReason() -> String {
        return self.offer?.unableReason ?? ""
    }
    
    /// 我的报价信息
    override func myOfferInfo() -> OfferInfoModel? {
        var myOffer = OfferInfoModel()
        myOffer.offerName = self.offer?.carrierName ?? ""
        myOffer.offerUnitPrice = self.offer?.quotedPrice ?? 0
        myOffer.offerTotalPrice = self.offer?.totalPrice ?? 0
        myOffer.dealPossible = self.offer?.offerPossibility ?? ""
        return myOffer
    }
    
    /// 其他人的报价信息
    override func otherOfferInfo() -> [OfferInfoModel] {
        return self.otherOfferUIModels()
    }
    
    /// 货源信息
    override func goodsSupplyInfo() -> GSInfoModel? {
        var info = GSInfoModel()
        info.status = SourceStatus(rawValue: self.offer?.dealStatus.rawValue ?? 5) ?? .other
        info.start = Util.contact(strs: [self.offer?.startProvince ?? "" , self.offer?.startCity ?? ""])
        info.end = Util.contact(strs: [self.offer?.endProvince ?? "" , self.offer?.endCity ?? ""])
        info.loadTime = self.offer?.loadingTime ?? 0
        info.goodsName = self.offer?.goodsName ?? ""
        info.goodsType = self.offer?.goodsType ?? ""
        info.goodsSummer = " "
        info.referenceUnitPrice = self.offer?.refercneceUnitPrice ?? 0
        info.referenceTotalPrice = self.offer?.refercneceTotalPrice ?? 0
        info.remark  = self.offer?.remark ?? " "
        return info
    }
}

// config tableView
extension GSDetailVC {
    
    func configTableView() -> Void {
        self.registerAllCells(tableView: self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    // 当前的 货源状态
    func configCurrentHallStatus() -> Void {
        self.currentStatus = SourceStatus(rawValue: self.offer?.dealStatus.rawValue ?? 0) ?? .other
    }
}

extension GSDetailVC {
    
    //MARK: - 获取报价信息
    func loadOffer() -> Void {
        let hallId = self.offer?.id ?? ""
        var query = OrderHallOfferQueryModel()
        query.hallId = hallId
        BaseApi.request(target: API.getOfferByOrderHallId(query), type: BaseResponseModel<OrderAndOfferResult>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.offerLists = data.data?.offerPage ?? []
                self?.offer = data.data?.zbnOrderHall
                self?.reloadPage()
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //TODO: - TODO 模拟报价数据
    func virtualOffers() -> [ZbnOfferModel] {
        var items: [ZbnOfferModel] = []
        for _ in 0 ... 10 {
            var item = ZbnOfferModel()
            item.carrierName = "王师傅"
            item.quotedPrice = 109
            item.totalPrice = 1000
            items.append(item)
        }
        return items
    }
    
    
    //MARK: - 其他z报价人的信息
    func otherOfferUIModels() -> [OfferInfoModel] {
        let uiModels = self.offerLists.map { (model) -> OfferInfoModel in
            var info = OfferInfoModel()
            info.offerName = model.carrierName
            info.offerUnitPrice = model.quotedPrice
            info.offerTotalPrice = model.totalPrice
            info.dealPossible = model.offerPossibility
            return info
        }
        return uiModels
    }
    
    //MARK: - 刷新当前页面
    func reloadPage() -> Void {
        let status = SourceStatus(rawValue: self.offer?.dealStatus.rawValue ?? 100) ?? .other
        self.tableView.reloadData()
        self.configBottom(status: status, tableView: self.tableView)
    }
}

//MARK: UITableViewDelegate / UITableViewDataSource
extension GSDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(status: self.currentStatus, indexPath: indexPath, for: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentSection(status: self.currentStatus, for: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentRows(status: self.currentStatus, section: section, for: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor(hex: "eeeeee")
    }
}
