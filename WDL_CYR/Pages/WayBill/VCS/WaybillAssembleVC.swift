//
//  WaybillAssembleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillAssembleVC: WaybillAssembleBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var pageInfo:WayBillInfoBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView(tableView: tableView)
    }
}

extension WaybillAssembleVC {
    
    //MARK: - 根据传入的数据，配置数据展示
    func configToDisplay() -> Void {
        switch self.currentDisplayMode {
        case .driverAssemble , .carrierAssemble:
            configSingleAssembleDisplay()
            
        default:
            self.configMultiAssembleDisplay()
        }
    }
    
    //MARK: - 配置司机配载和承运人配载
    func configSingleAssembleDisplay() -> Void {
        let model = WaybillAssembleUIModel()
//        model.driverName =
    }
    
    //MARK: - 配置 运输计划的配载展示
    func configMultiAssembleDisplay() -> Void {
        
    }
}
