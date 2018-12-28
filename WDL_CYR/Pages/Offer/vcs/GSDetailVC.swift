//
//  GSDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import HandyJSON
class GSDetailVC: GSDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var currentStatus:SourceStatus = .other // 判断当前的报价状态
    private var offerLists:[ZbnOfferModel] = []     // 报价数据
    
    
    public var offer:OfferOrderHallResultApp?
    //自动成交时间
    private var autoTime: TimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.configCurrentHallStatus()
        self.loadOffer()
       // 获取距离下次成交时间的请求
        getAutoTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: 获取距离下次成交时间的请求
    func getAutoTime() -> Void {
   
        BaseApi.request(target: API.getAutoDealTimer(offer?.hallId ?? ""), type: BaseResponseModel<Any>.self)
        
            .subscribe(onNext: {(data) in
                if (data.data != nil) {
                    let dic = data.data as! Dictionary<String, Any>
                    let str = dic["surplusTurnoverTime"]  as? TimeInterval
                    
                    if (str != nil) {
                    let time = (dic["surplusTurnoverTime"] ?? 0) as! TimeInterval

                    self.autoTime = time
                    }
                }

                print("时间：\(String(describing: data.data))")
                }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: overrride
    // 取消报价
    override func cancelOffer() -> Void {
        AlertManager.showCustomTitleAndContentAlert(context: self, actionTitles: ["取消" , "确定"], title: "", content: "确定取消该报价?") {[weak self] (index) in
            if index == 1 {
                self?.cancelOfferHandle(hallId: self?.offer?.id ?? "", offerId: self?.offer?.offerId ?? "")
            }
        }
    }
    
    // 重新报价
    override func toOfferAgain() -> Void {
        AlertManager.showCustomTitleAndContentAlert(context: self, actionTitles: ["取消" , "确定"], title: "", content: "确定重新报价?") {[weak self] (index) in
            if index == 1 {
                var resource = ResourceDetailUIModel()
                resource.resource = CarrierQueryOrderHallResult.deserialize(from: self?.offer?.toJSONString())
                self?.toChooseOfferType(resource: resource)
            }
        }
    }
    
    // 竞标中 竞标中的倒计时
    override func bidding_timer() -> TimeInterval {
        return self.autoTime ?? 0
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
    override func otherOfferInfo() -> [OfferInfoModel]? {
        if showOtherOfferInfo() == true {
            return self.otherOfferUIModels()
        }
        return nil
    }
    
    /// 货源信息
    override func goodsSupplyInfo() -> GSInfoModel? {
        var info = GSInfoModel()
        info.status = SourceStatus(rawValue: self.offer?.dealStatus.rawValue ?? 5) ?? .other
        info.start = Util.contact(strs: [self.offer?.startProvince ?? "" , self.offer?.startCity ?? "" , self.offer?.startDistrict ?? ""])
        info.end = Util.contact(strs: [self.offer?.endProvince ?? "" , self.offer?.endCity ?? "" ,self.offer?.endDistrict ?? ""])
        info.loadTime = self.offer?.loadingTime ?? 0
        info.goodsName = self.offer?.goodsName ?? ""
        info.goodsType = self.offer?.goodsType ?? ""
        let weight = Util.floatPoint(num: 1, floatValue: self.offer?.goodsWeight ?? 0)
        info.goodsSummer = Util.concatSeperateStr(seperete: "| " , strs: weight,self.offer?.vehicleType,self.offer?.packageType,self.offer?.vehicleLength,self.offer?.vehicleWidth)
        info.referenceUnitPrice = self.offer?.refercneceUnitPrice ?? 0
        info.referenceTotalPrice = self.offer?.refercneceTotalPrice ?? 0
        info.remark  = self.offer?.remark ?? " "
        info.id = self.offer?.id ?? ""
        return info
    }
    
    override func showMyOffer() -> Bool {
        return self.offer?.offerType == 1;
    }
    
    override func showOtherOfferInfo() -> Bool {
        //MARK: - 是否获取其他人的x报价信息
        /// - 若货源信息是由TMS经销商来源
        /// - 有明报显示 ，暗报不显示其他人报价
        /// - 若货源信息是由第三方发布的都可见
        if self.offer?.sourceType == 2 && self.offer?.offerType == 2 { // 不显示其他人报价
            return false
        }
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configBottom(status: self.offer?.dealStatus ?? .reject, tableView: self.tableView)
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
        switch self.offer?.dealStatus ?? .reject {
        case .canceled:
            self.currentStatus = .canceled
            break
        case .deal,.done:
            self.currentStatus = .dealed
            break
        case .inbinding:
            self.currentStatus = .bidding
            break
        case .notDone:
            self.currentStatus = .notDeal
            break
        case .reject:
            self.currentStatus = .rejected
            break
        case .willDesignate:
            self.currentStatus = .willDesignate
            break
        }
    }
}

extension GSDetailVC {
    
    //MARK: - 获取其他人报价信息
    func loadOffer() -> Void {
        let hallId = self.offer?.id ?? ""
        self.offer?.hallId = hallId
        self.loadOtherInfo(model: self.offer) { (offers, error) in
            guard let others = offers else {
                return
            }
            self.offerLists = others
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - 其他z报价人的信息
    func otherOfferUIModels() -> [OfferInfoModel] {
        let uiModels = self.offerLists.map { (model) -> OfferInfoModel in
            var info = OfferInfoModel()
            info.offerName = model.carrierName
            info.offerUnitPrice = model.quotedPrice
            info.offerTotalPrice = model.totalPrice
            info.dealPossible = model.offerPossibility
//            info.showOffer = model
            return info
        }
        return uiModels
    }
}

extension GSDetailVC {
    
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

