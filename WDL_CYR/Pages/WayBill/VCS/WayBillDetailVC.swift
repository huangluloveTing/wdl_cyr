//
//  WayBillDetailVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/1.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class WayBillDetailVC: WaybillDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var transportNo: String?
    
    public var waybillInfo:WayBillInfoBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView(tableView: tableView)
        self.loadDetailData(hallId: self.waybillInfo?.hallId ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func currentConfig() {
        
    }
    
    
    override func toCommitComment() {
        let assembleVC = WaybillAssembleVC()
        assembleVC.pageInfo = currentWaybillDetailInfo()
        assembleVC.currentDisplayMode = .driverAssemble
        self.pushToVC(vc: assembleVC, title: "配载")
    }
}
