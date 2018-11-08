//
//  WaybillDetailBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

enum WaybillDisplayMode {
    case unassemble_showAssemble    //未配载，显示配载的情况，即订单来源为 1、2 的情况
    case unassemble_showSpecial     //未配载，运单来源为3 的情况
    case unassemble_showDesignate   //未配载，运单来源为4 的情况
    case doing_showWillTransport    //未完成，待起运
    case doing_showTransporting     //未完成，运输中
    case doing_showWillSign         //未完成，待签收
    case doing_showNotStart         //未完成的待办单
    case done_notComment            //已完成，未评价
    case done_commentOne            //已完成，一个评价
    case done_commentAll            //已完成，互评
}

class WaybillDetailBaseVC: NormalBaseVC {
    
    private var currentTableView:UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - config tableView
extension WaybillDetailBaseVC {
    
    func configTableView(tableView:UITableView) -> Void {
        currentTableView = tableView
        currentTableView?.delegate = self
        currentTableView?.dataSource = self
    }
    
    func registerAllCells() -> Void {
        
    }
}

//MARK: - UITableViewDelegate , UITableViewDataSource
extension WaybillDetailBaseVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
