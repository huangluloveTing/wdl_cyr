//
//  OfferBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/23.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class OfferBaseVC: MainBaseVC {
    
    public let NotDoneStatus = ["不限","竞价中","已驳回","未成交","已取消"]
    
    private var baseTableView:UITableView?
    
    public var pageSize:Int = 20                // 当前页面的展示每页数量
    public var currentPageInfo:OfferPageInfo?   // 后台获取的页面数据
    public var currentUIModels:[OfferUIModel] = [] // 当前页面展示的model 数组
    
    
    // 状态下拉视图
    var statusView : GoodsSupplyStatusDropView?
    var timeChooseView : DropInputDateView?
    
//    lazy var 

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.baseTableView?.refreshState.asObservable()
            .distinctUntilChanged()
            .filter({ (state) -> Bool in
                return state != .EndRefresh
            })
            .subscribe(onNext: { [weak self](state) in
                self?.endRefresh()
                if state == .LoadMore {
                    self?.pageSize += 20
                    self?.footerLoadMore(pageSize: self?.pageSize ?? 20)
                } else {
                    self?.pageSize = 20
                    self?.headerRefresh()
                }
            })
            .disposed(by: dispose)
    }
    
    // override
    func headerRefresh() -> Void {} // 下拉刷新
    func footerLoadMore(pageSize:Int) -> Void {} // 下拉刷新
}

// 将UI的tableView配置过来
extension OfferBaseVC {
    func defineTableView(tableView:UITableView , canRefresh:Bool? = true , canLoadMore:Bool? = true) -> Void {
        self.baseTableView = tableView
        if canRefresh == true {
            self.baseTableView?.pullRefresh()
        }
        if canLoadMore == true {
            self.baseTableView?.upRefresh()
        }
    }
    
    func endRefresh() -> Void {
        self.baseTableView?.endRefresh()
    }
    
    func noMoreData() -> Void {
        self.baseTableView?.noMore()
    }
}

extension OfferBaseVC {
    // 跳转去报价详情
    func toOfferDetail(index:Int) -> Void {
        let offer = self.currentPageInfo?.list?[index]
        let offerDetailVC = GSDetailVC()
        offerDetailVC.offer = offer
        self.pushToVC(vc: offerDetailVC, title: "报价详情")
    }
    
    //MARK: - 去查看运单
    func toWaybillPage(index:Int) -> Void {
        
        let detailVC = WayBillDetailVC()
        var hall = WayBillInfoBean()
        hall.hallId = self.currentPageInfo?.list![index].id
        detailVC.waybillInfo = hall
        //        detailVC.transportNo = info.transportNo ?? ""
        self.push(vc: detailVC, title: "运单详情")
    }
}

// 获取数据
extension OfferBaseVC {
    
    // 1:未完成 2：已完成
    // 0=驳回 1=竞价中 2=成交 5=已取消 6= 未成交
    func loadOfferData(status:Int ,
                       pageSize:Int ,
                       start:TimeInterval? ,
                       end:TimeInterval? ,
                       dealStatus:Int? ,
                       carrierName:String? ,
                       result:((OfferPageInfo? ,Error?) ->())?) -> Void {
        var query = OfferQueryModel()
        query.dealStatus = dealStatus
        query.status = status
        query.carrierName = carrierName
        query.startTime = start
        query.endTime = end
        query.pageSize = pageSize
        BaseApi.request(target: API.selectOwnOffer(query), type: BaseResponseModel<OfferPageInfo>.self)
            .subscribe(onNext: { (data) in
                if let closure = result {
                    closure(data.data , nil)
                }
            }, onError: { (error) in
                if let closure = result {
                    closure(nil , error)
                }
            })
            .disposed(by: dispose)
    }
    
    // 根据后台接口，获取当前页面的展示数据
    func configNetDataToDisplay(pageInfo:OfferPageInfo?) -> [OfferUIModel] {
        self.endRefresh()
        self.currentPageInfo = pageInfo
        let total = self.currentPageInfo?.total ?? 0
        let currentCount = self.currentPageInfo?.list?.count ?? 0
        if total <= currentCount {
            self.noMoreData()
        }
        //报价数据
        let currentList = self.currentPageInfo?.list?.map({ (result) -> OfferUIModel in
            var offer = OfferUIModel()
            // 可能性 高中低
            offer.possible = result.offerPossibility
            offer.unitPrice = result.quotedPrice
            offer.totalPrice = result.totalPrice
            offer.start = Util.contact(strs: [result.startProvince , result.startCity])
            offer.end = Util.contact(strs: [result.endProvince , result.endCity])
            let loadTime = Util.dateFormatter(date: result.loadingTime/1000, formatter: "yyyy-MM-dd") + " 装货 "
            let weight = String(result.goodsWeight) + "吨"
            let length = result.vehicleLength
            let type = result.vehicleType
            let package = result.packageType
            offer.truckInfo =  Util.contact(strs: [loadTime , result.goodsType], seperate: "  ")
            offer.goodsInfo = Util.contact(strs: [weight , length , type , package], seperate: " | ")
            offer.isSelf = false
            offer.company = result.companyName
            offer.isAttention = (result.shipperCode?.count ?? 0 > 0) ? true : false
            offer.reportStatus = result.dealStatus
            offer.designateStatus  = 0
            offer.avatorURL = result.companyLogo //头像
            return offer
        })
        return currentList ?? []
    }
}

// dropView
extension OfferBaseVC : DropHintViewDataSource {
    
    func configDropView(dropView:DropHintView) -> Void {
        dropView.dataSource = self
        dropView.tabTitles(titles: ["报价时间","报价状态"])
        dropView.dropTapClosure = {(index) in
            print("current tap index ： \(index)")
        }
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        if index == 0 {
            if self.timeChooseView == nil {
                self.timeChooseView = startAndEndTimeChooseViewGenerate()
            }
            return timeChooseView!
        } else {
            if self.statusView == nil {
                self.statusView = statusDropViewGenerate(statusTitles: NotDoneStatus)
            }
            return self.statusView!
        }
    }
}
