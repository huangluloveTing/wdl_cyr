//
//  WaybillPlanVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2019/1/29.
//  Copyright © 2019 yinli. All rights reserved.
//  运输计划

import UIKit
import RxSwift

class WaybillPlanVC: WayBillBaseVC , ZTScrollViewControllerType {
    
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
        loadTransportPlan()
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
        loadTransportPlan()
    }
    
    override func footerLoadMore() {
        //        self.loadUnAssembleDatas(refresh: false)
        loadTransportPlan()
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


extension WaybillPlanVC {
    // 运输计划运单列表
    func loadTransportPlan() -> Void {
         configRequestParams(status: 1, transportStatus: self.currentStatus, search: self.queryBean.searchWord, startTime:self.currentStartTime , endTime: self.currentEndTime)
        self.queryBean.transportStatus = -1
        BaseApi.request(target: API.findTransportByTransportStatus(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](res) in
                self?.handlePlanTransports(result: res.data)
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    
    func handlePlanTransports(result:WayBillPageBean?) -> Void {
        self.endRefresh()
        let plans:[WayBillInfoBean] = result?.list ?? []
        var newPlans: [WayBillInfoBean] = []
        for info in plans {
            var newInfo = info;
            newInfo.comeType = 3;
            newInfo.origin = Util.contact(strs: [info.startProvince , info.startCity , info.startDistrict], seperate: "-")
            newInfo.destination = Util.contact(strs: [info.endProvince , info.endCity , info.endDistrict], seperate: "-")
            newInfo.hallId = info.id
            newPlans.append(newInfo)
        }
        self.refreshContents(items: newPlans);
        if self.currentDataSource.count >= (result?.total ?? 0)  {
            self.endRefreshAndNoMoreData()
        } else {
            self.resetFooter()
        }
    }
}
