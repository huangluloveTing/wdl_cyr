//
//  WaybillNotDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/30.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WaybillNotDoneVC: WayBillBaseVC , ZTScrollViewControllerType{
    func willDisappear() {
        self.dropView.hiddenDropView()
    }
    
    
    @IBOutlet weak var dropView: DropHintView!
    @IBOutlet weak var tableView: UITableView!
//    var dataSource: [WayBillInfoBean]?
    
    private var currentStatus:Int = -1
    private var currentStartTime:TimeInterval?
    private var currentEndTime:TimeInterval?

    func didShow() {
        self.beginRefresh()
    }
    
    func willShow() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentTabStatus(tab: .Doing)
        self.configTableView(tableView: tableView)
        self.configHeaderAndFooterRefresh()
        self.loadDoingDatas(refresh: false)
    }
    

    override func headerRefresh() {
        self.loadDoingDatas(refresh: true)
    }
    
    override func footerLoadMore() {
        self.loadDoingDatas(refresh: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        self.currentStatus = index - 1
//        运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 -1=不限
        self.beginRefresh()
        self.dropView.currenDropView?.hiddenDropView()
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        if sure == true {
            self.currentStartTime = startTime
            self.currentEndTime = endTime
            self.beginRefresh()
        }
        self.dropView.currenDropView?.hiddenDropView()
    }
    
    override func curreenStatusTitles() -> [String] {
        return ["全部","待办单","待起运","运输中","待签收"]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !addDrop {
            toConfigDropView(dropView: self.dropView)
            addDrop = true;
        }
    }
    
    override func currentSearch(text: String) {
        self.queryBean.searchWord = text
        self.beginRefresh()
    }
}

extension WaybillNotDoneVC {
    
    func loadDoingDatas(refresh:Bool) -> Void {
        self.loadWayBillUnCompletedData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
            self.endRefresh()
            self.refreshContents(items: info?.list ?? [])
            if self.currentDataSource.count >= (info?.total ?? 0)  {
                self.endRefreshAndNoMoreData()
            } else {
                self.resetFooter()
            }
        }
    }
}

