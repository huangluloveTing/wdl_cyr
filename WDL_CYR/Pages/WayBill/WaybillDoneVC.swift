//
//  WaybillDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/30.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WaybillDoneVC: WayBillBaseVC , ZTScrollViewControllerType {
    func willDisappear() {
        self.dropView.hiddenDropView()
    }
    
    
    @IBOutlet weak var dropView: DropHintView!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentStatus:Int = -1
    private var currentStartTime:TimeInterval?
    private var currentEndTime:TimeInterval?
    
    func willShow() {
    
    }
    
    func didShow() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addSearchBar(to: self.tableView, placeHolder: "搜索托运人/承运人/姓名/电话号码")
        self.setCurrentTabStatus(tab: .Done)
        self.configTableView(tableView: tableView)
        self.configHeaderAndFooterRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        if index == 0 {
            self.currentStatus = -1
        }
        self.currentStatus = 6
        self.beginRefresh()
        
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        if sure == true {
            self.currentStartTime = startTime
            self.currentEndTime = endTime
            self.beginRefresh()
        } else {
            self.currentStartTime = nil
            self.currentEndTime = nil
            self.beginRefresh()
        }
        self.dropView.currenDropView?.hiddenDropView()
    }

    override func headerRefresh() {
        self.loadDoneDatas(refresh: true)
    }
    
    override func curreenStatusTitles() -> [String] {
        return ["全部","已签收"]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.toConfigDropView(dropView: self.dropView)
    }
}


extension WaybillDoneVC {
    
    func loadDoneDatas(refresh:Bool) -> Void {
        self.loadCompletedData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
            self.endRefresh()
            if refresh == true {
                self.refreshContents(items: info?.list ?? [])
            } else {
                self.addContentItems(items: info?.list ?? [])
            }
            if self.currentDataSource.count  >= (info?.total ?? 0)  {
                self.endRefreshAndNoMoreData()
            } else {
                self.resetFooter()
            }
        }
    }
}
