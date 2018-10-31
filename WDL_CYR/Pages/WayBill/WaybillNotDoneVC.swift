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
    //请求参数
    private var queryBean : QuerytTransportListBean = QuerytTransportListBean()
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func currentConfig() {
        self.currentTableView = self.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSearchBar(to: self.tableView, placeHolder: "搜索托运人/承运人/姓名/电话号码")
        self.toConfigDropView(dropView: self.dropView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        //运单列表数据请求
        self.loadWayBill()
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

extension WaybillNotDoneVC
{
    
    //运单数据请求
    //    func loadWayBill() -> Observable<WayBillPageBean> {
    //        //token
    //        self.queryBean.token = WDLCoreManager.shared().userInfo?.token ?? ""
    //        //self.queryBean.carrierId = WDLCoreManager.shared().userInfo?.carrierNo ?? ""
    //        // 顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,
    //        self.queryBean.completeStatus = 1
    //        // 运单状态： -1 不限 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收
    //        self.queryBean.transportStatus = -1
    //        //搜索字段
    //        self.queryBean.searchWord = ""
    //        //开始结束时间
    //        self.queryBean.startTime = ""
    //        self.queryBean.endTime = ""
    //
    //        let result = BaseApi.request(target: API.ownTransportPage(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
    //            .catchErrorJustReturn(BaseResponseModel<WayBillPageBean>())
    //            .map { (data) -> WayBillPageBean in
    //                return data.data ?? WayBillPageBean()
    //        }
    //        return result
    //    }
    //
    
    
    
    func loadWayBill(){
        //token
        self.queryBean.token = WDLCoreManager.shared().userInfo?.token ?? ""
        //self.queryBean.carrierId = WDLCoreManager.shared().userInfo?.carrierNo ?? ""
        // 顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,
        self.queryBean.completeStatus = 2
        // 运单状态： -1 不限 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收
        self.queryBean.transportStatus = -1
        //搜索字段
        self.queryBean.searchWord = ""
        //开始结束时间
        self.queryBean.startTime = ""
        self.queryBean.endTime = ""
        
        BaseApi.request(target: API.ownTransportPage(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.dataSource = data.data?.list;
//                self?.tableView.reloadData()
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
}

////MARK:tableview delegate
//extension WaybillNotDoneVC :  UITableViewDelegate , UITableViewDataSource {
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return self.dataSource?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WaybillCarrierInfoCell.self)") as! WaybillCarrierInfoCell
//        // 顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,
//        cell.contentInfo(info: self.dataSource![indexPath.row], currentBtnIndex: 1)
//        return cell
//    }
//
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//}
