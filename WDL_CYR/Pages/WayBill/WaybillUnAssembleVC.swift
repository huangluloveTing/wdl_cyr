//
//  WaybillUnAssembleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/30.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class WaybillUnAssembleVC: WayBillBaseVC , ZTScrollViewControllerType {
    
    func willDisappear() {
        self.dropView.hiddenDropView()
    }
    
    
    @IBOutlet weak var dropView: DropHintView!
    @IBOutlet weak var tableView: UITableView!
    private var currentStatus:Int = -1
    private var currentStartTime:TimeInterval?
    private var currentEndTime:TimeInterval?
    
    func willShow() {
     print("未配载willshow")
    }
 
    
    func didShow() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addSearchBar(to: self.tableView, placeHolder: "搜索托运人/承运人/姓名/电话号码")
        self.configTableView(tableView: self.tableView)
        self.loadUnAssembleDatas(refresh: true)
        self.setCurrentTabStatus(tab: .UnAssemble)
        self.configHeaderAndFooterRefresh()
    }
  
    // 点击状态
    override func statusChooseHandle(index: Int) {
        if index == 0 {
            self.currentStatus = -1
        }
        self.currentStatus = 0
        self.beginRefresh()
        self.dropView.currenDropView?.hiddenDropView()
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
        self.loadUnAssembleDatas(refresh: true)
    }
    
    override func footerLoadMore() {
        self.loadUnAssembleDatas(refresh: false)
    }
    
    override func curreenStatusTitles() -> [String] {
        return ["不限","待办单"]
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

//MARK: - load data
extension WaybillUnAssembleVC
{
}

extension WaybillUnAssembleVC {
    func loadUnAssembleDatas(refresh:Bool) -> Void {
        self.loadUnAssembleData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
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
