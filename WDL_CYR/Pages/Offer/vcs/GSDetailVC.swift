//
//  GSDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetailVC: GSDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var currentStatus:SourceStatus = .other
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: overrride
    // 取消报价
    override func cancelOffer() -> Void {
        
    }
     // 重新报价
    override func toOfferAgain() -> Void {
        
    }
    
    // 竞标中 竞标中的倒计时
    override func bidding_timer() -> TimeInterval {
        return 0
    }
    // 已驳回 驳回原因
    override func rejectReason() -> String {
        return ""
    }
    // 未成交原因
    override func notDealReason() -> String {
        return ""
    }
    // 我的报价信息
    override func myOfferInfo() -> OfferInfoModel? {
        return nil
    }
    //其他人的报价信息
    override func otherOfferInfo() -> [OfferInfoModel] {
        return []
    }
    // 货源信息
    override func goodsSupplyInfo() -> GSInfoModel? {
        return nil
    }
}

// config tableView
extension GSDetailVC {
    
    func configTableView() -> Void {
        self.registerAllCells(tableView: self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

//MARK: UITableViewDelegate / UITableViewDataSource
extension GSDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(status: self.currentStatus, indexPath: indexPath, for: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentSection(status: self.currentStatus, for: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentRows(status: self.currentStatus, section: section, for: tableView)
    }
}
