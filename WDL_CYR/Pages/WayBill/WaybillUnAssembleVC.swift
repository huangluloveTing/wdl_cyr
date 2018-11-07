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
        self.addSearchBar(to: self.tableView, placeHolder: "搜索托运人/承运人/姓名/电话号码")
        self.toConfigDropView(dropView: self.dropView)
        self.configTableView(tableView: self.tableView)
        self.loadUnAssembleDatas(refresh: true)
    }
  
    // 点击状态
    override func statusChooseHandle(index: Int) {
     
    }
    
    // 选择时间
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
       
    }
}

//MARK: - load data
extension WaybillUnAssembleVC
{
    //test  承运人操作运单所有涉及的按钮请求（拒绝，接受，取消运输，继续运输）
    func acceptRequest(){
        //token
//        let token = WDLCoreManager.shared().userInfo?.token ?? ""
         //(integer): 操作类型（3=拒绝，4=接受，8=取消运输，7=继续运输） ,
        let handleType = 4
        // 货源id ,(只有在操作 - 继续运输 提交时间才将hallid传入)
        let hallId = ""
        //继续运输时）装货时间 ,运单部分有4钟按钮都在这里处理
        let loadingTime = ""
        //运单号
        let transportNo = "Y181017000005"
        
    
        BaseApi.request(target:  API.carrierAllButtonAcceptTransportState(handleType,loadingTime, transportNo,hallId), type: BaseResponseModel<AnyObject>.self)
            .subscribe(onNext: { (model) in
                self.showSuccess(success: "接受成功", complete: {[weak self] in
                    //刷新tableview
                })
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}


extension WaybillUnAssembleVC {
    
    func loadUnAssembleDatas(refresh:Bool) -> Void {
        self.loadUnAssembleData(transportStatus: self.currentStatus, startTime: self.currentStartTime, endTime: self.currentEndTime, search: "") { (info) in
            if refresh == true {
                self.refreshContents(items: info?.list ?? [])
                return
            }
            self.addContentItems(items: info?.list ?? [])
        }
    }
}
