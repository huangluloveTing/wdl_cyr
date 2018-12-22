//
//  OfferDealVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferDealVC: OfferBaseVC , ZTScrollViewControllerType {
    func willDisappear() {
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        self.searchBar.delegate = self;
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Offer_DoneCell.self)") as! Offer_DoneCell
        let offerModel = self.currentUIModels[indexPath.row]
        cell.showInfo(info: offerModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUIModels.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.contentView.shadowBorder(radius: 10,
                                          bgColor: UIColor.white,
                                          shadowColor: UIColor(hex: "C9C9C9"),
                                          shadowOpacity: 0.5,
                                          insets: UIEdgeInsetsMake(15, 15, 0, 15))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let row = indexPath.row
//            let info = self.currentPageInfo?.list![indexPath.row]
//            if info?.dealStatus == .deal {
            self.toWaybillPage(index: row)
//                return
//            }
//            self.toOfferDetail(index: row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightForRow(at: indexPath)
    }
}

extension OfferDealVC {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == self.searchBar {
            self.currentSearchContent = searchBar.text
            self.tableView.beginRefresh()
        }
    }
}
