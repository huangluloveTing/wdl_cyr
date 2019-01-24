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
//        self.addSearchBar(to: self.tableView, placeHolder: "搜索托运人/承运人/姓名/电话号码")
        self.configTableView(tableView: self.tableView)
//        self.loadUnAssembleDatas(refresh: true)
        combineUnAssembleRequest()
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
        } 
        self.dropView.currenDropView?.hiddenDropView()
    }
    
    override func headerRefresh() {
//        self.loadUnAssembleDatas(refresh: true)
        combineUnAssembleRequest()
    }
    
    override func footerLoadMore() {
//        self.loadUnAssembleDatas(refresh: false)
        combineUnAssembleRequest()
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
    func loadUnAssembleDatas() -> Observable<[WayBillInfoBean]> {
        return BaseApi.request(target: API.ownTransportPage(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
            .retry(5)
            .map { (res) -> [WayBillInfoBean] in
                return res.data?.list ?? []
            }
    }
    
    func loadTransportPlan() -> Observable<[WayBillInfoBean]> {
        return BaseApi.request(target: API.findTransportByTransportStatus(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
            .retry(5)
            .map { (res) -> [WayBillInfoBean] in
                return res.data?.list ?? []
            }
    }
    
    func combineUnAssembleRequest() -> Void {
//        transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: ""
        configRequestParams(status: 1, transportStatus: self.currentStatus, search: self.queryBean.searchWord, startTime:self.currentStartTime , endTime: self.currentEndTime)
        Observable.zip(self.loadTransportPlan() , self.loadUnAssembleDatas())
            .asObservable()
            .subscribe(onNext: { [weak self](res1, res2) in
                self?.combineUnassembleResult(normals: res2, plans: res1)
                }, onError: { [weak self](error) in
                    self?.endRefresh()
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    func combineUnassembleResult(normals:[WayBillInfoBean] , plans:[WayBillInfoBean]) -> Void {
        self.endRefresh()
        var newPlans:[WayBillInfoBean] = []
        for info in plans {
            var newInfo = info;
            newInfo.comeType = 3;
            newInfo.origin = Util.contact(strs: [info.startProvince , info.startCity , info.startDistrict], seperate: "-")
            newInfo.destination = Util.contact(strs: [info.endProvince , info.endCity , info.endDistrict], seperate: "-")
            newInfo.hallId = info.id
            newPlans.append(newInfo)
        }
        newPlans.append(contentsOf: normals)
        self.refreshContents(items: newPlans);
    }
}
