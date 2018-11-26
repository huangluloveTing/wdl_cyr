//
//  OfferNotDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OfferNotDoneVC: OfferBaseVC , ZTScrollViewControllerType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropHintView: DropHintView!
    
    private var startTime:TimeInterval?
    private var endTime:TimeInterval?
    private var dealStatus:WDLOfferDealStatus?
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: self.tableView)
        self.configDropView(dropView: self.dropHintView)
        self.configTableView()
        self.tableView.beginRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func bindViewModel() {
        self.tableView.refreshState.asObservable()
            .share(replay: 1)
            .filter { (state) -> Bool in
                return state != .EndRefresh
            }
            .subscribe(onNext: { [weak self](state) in
                self?.tableView.endRefresh()
                if state == .LoadMore {
                    self?.pageSize += 20
                } else {
                    self?.tableView.removeCacheHeights()
                    self?.pageSize = 20
                }
                self?.loadOffers()
            })
            .disposed(by: dispose)
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        if index == 0 {
            self.dealStatus = nil
        }
        if index == 1 {
            self.dealStatus = .inbinding
        }
        if index == 2 {
            self.dealStatus = .reject
        }
        if index == 3 {
            self.dealStatus = .notDone
        }
        if index == 4 {
            self.dealStatus = .canceled
        }
        self.tableView.beginRefresh()
        self.dropHintView.hiddenDropView()
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        if sure {
            self.startTime = startTime
            self.endTime = endTime
            self.tableView.beginRefresh()
        }
        self.dropHintView.hiddenDropView()
    }
    
    override func callBackForRefresh(param: Any?) {
        self.loadOffers()
    }
}

// tableView
extension OfferNotDoneVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedRowHeight = 0
        self.registerCell(nibName: "\(Offer_NotDoneCell.self)", for: self.tableView)
    }
}

// 获取数据
extension OfferNotDoneVC {
    
    // 获取报价数据
    func loadOffers() -> Void {
        self.loadOfferData(status: 1, pageSize: self.pageSize, start: self.startTime, end: self.endTime, dealStatus: self.dealStatus?.rawValue) { [weak self](res, error) in
            self?.tableView.endRefresh()
            guard let pageInfo = res else {
                self?.showFail(fail: error?.localizedDescription, complete: nil)
                return
            }
            self?.currentUIModels = self?.configNetDataToDisplay(pageInfo: pageInfo) ?? []
            self?.tableView.reloadData()
        }
    }
}

// UITableViewDelegate , UITableViewDataSource
extension OfferNotDoneVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Offer_NotDoneCell.self)") as! Offer_NotDoneCell
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
        self.toOfferDetail(index: row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightForRow(at: indexPath)
    }
}
