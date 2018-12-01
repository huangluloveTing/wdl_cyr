//
//  OfferDealVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferDealVC: OfferBaseVC , ZTScrollViewControllerType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropHintView: DropHintView!
    
    private var currentSearchContent:String? // 当前的搜索内容
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: tableView , canRefresh: true , canLoadMore: true)
        self.configTableView()
        self.tableView.beginRefresh()
    }
    
    override func bindViewModel() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func headerRefresh() {
        self.loadOffers()
    }
    
    override func footerLoadMore(pageSize: Int) {
        self.loadOffers()
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        
    }
}

// tableView
extension OfferDealVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.registerCell(nibName: "\(Offer_DoneCell.self)", for: self.tableView)
        self.registerCell(nibName: "\(OfferSearchCell.self)", for: tableView)
    }
}

extension OfferDealVC {
    // 获取报价数据
    func loadOffers() -> Void {
        self.loadOfferData(status: 2,
                           pageSize: self.pageSize,
                           start: nil,
                           end: nil,
                           dealStatus: nil,
                           carrierName: self.currentSearchContent) { [weak self](res, error) in
            guard let pageInfo = res else {
                self?.showFail(fail: error?.localizedDescription, complete: nil)
                return
            }
            self?.currentUIModels = self?.configNetDataToDisplay(pageInfo: pageInfo) ?? []
            if (self?.currentUIModels.count ?? 0) >= (res?.total ?? 0){
                self?.noMoreData()
            }
            self?.tableView.reloadData()
        }
    }
}

// UITableViewDelegate , UITableViewDataSource
extension OfferDealVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(className: OfferSearchCell.self)
            cell.showPlaceholder(place: "搜索托运人名称/企业名称")
            cell.searchClosure = {[weak self] (search) in
                self?.currentSearchContent = search
                self?.tableView.beginRefresh()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Offer_DoneCell.self)") as! Offer_DoneCell
        let offerModel = self.currentUIModels[indexPath.row - 1]
        cell.showInfo(info: offerModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUIModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 0{
            cell.contentView.shadowBorder(radius: 10,
                                          bgColor: UIColor.white,
                                          shadowColor: UIColor(hex: "C9C9C9"),
                                          shadowOpacity: 0.5,
                                          insets: UIEdgeInsetsMake(15, 15, 0, 15))
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let row = indexPath.row - 1
            let info = self.currentPageInfo?.list![indexPath.row - 1]
//            if info?.dealStatus == .deal {
            self.toWaybillPage(index: row)
//                return
//            }
//            self.toOfferDetail(index: row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightForRow(at: indexPath)
    }
}
