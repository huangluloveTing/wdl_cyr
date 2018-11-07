//
//  WaybillNotDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/30.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WaybillNotDoneVC: WayBillBaseVC , ZTScrollViewControllerType{
    
    @IBOutlet weak var dropView: DropHintView!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [WayBillInfoBean]?
    
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
        self.toConfigDropView(dropView: self.dropView)
        self.setCurrentTabStatus(tab: .Doing)
        self.configTableView(tableView: tableView)
        self.configHeaderAndFooterRefresh()
        self.loadDoingDatas(refresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    override func headerRefresh() {
        self.loadDoingDatas(refresh: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击状态
    override func statusChooseHandle(index: Int) {
        
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        
    }
}

extension WaybillNotDoneVC {
    
    func loadDoingDatas(refresh:Bool) -> Void {
        self.loadWayBillUnCompletedData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
            if refresh == true {
                self.refreshContents(items: info?.list ?? [])
                return
            }
            self.addContentItems(items: info?.list ?? [])
        }
    }
}

