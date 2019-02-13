//
//  WaybillBreakVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2019/2/13.
//  Copyright © 2019 yinli. All rights reserved.
//

import UIKit

class WaybillBreakVC: WayBillBaseVC,ZTScrollViewControllerType {

    func willShow() {
        
    }
    
    
    func willDisappear() {
        self.dropView.hiddenDropView()
    }
    
    
    @IBOutlet weak var dropView: DropHintView!
    @IBOutlet weak var tableView: UITableView!
    private var currentStatus:Int = -1
    private var currentStartTime:TimeInterval?
    private var currentEndTime:TimeInterval?
    
    func didShow() {
        self.beginRefresh()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView(tableView: self.tableView)
        loadDoneDatas(refresh: true)
        self.setCurrentTabStatus(tab: .UnAssemble)
        self.configHeaderAndFooterRefresh()
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        self.currentStatus = index - 1
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
    
    override func headerRefresh() {
        //        self.loadUnAssembleDatas(refresh: true)
        loadDoneDatas(refresh: true)
    }
    
    override func footerLoadMore() {
        //        self.loadUnAssembleDatas(refresh: false)
        loadDoneDatas(refresh: false)
    }
    
    override func curreenStatusTitles() -> [String] {
        return ["不限"]
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
        self.view.endEditing(true)
    }

}

extension WaybillBreakVC {
    
    func loadDoneDatas(refresh:Bool) -> Void {
        self.loadBreakData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
            self.endRefresh()
            self.refreshContents(items: info?.list ?? [])
            if self.currentDataSource.count  >= (info?.total ?? 0)  {
                self.endRefreshAndNoMoreData()
            } else {
                self.resetFooter()
            }
        }
    }
}
