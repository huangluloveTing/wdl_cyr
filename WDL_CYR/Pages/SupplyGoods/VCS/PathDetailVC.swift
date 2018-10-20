//
//  PathDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class PathDetailVC: AttentionDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var lineHall:FollowLineOrderHallResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: self.tableView)
        self.configResources()
    }
    
    override func pageTitle() -> String? {
        let start = self.lineHall.startProvince + self.lineHall.startCity
        let end = self.lineHall.endProvince + self.lineHall.endCity
        return start + "-" + end
    }
    
    func configResources() -> Void {
        let items = self.lineHall.hall.map { (res) -> ResourceHallUIModel in
            let truckInfo = Util.dateFormatter(date: res.loadingTime, formatter: "mm-dd") + " 装货" + " 玻璃"
            let goodsInfo = Util.contact(strs: [String(format: "%.f", res.goodsWeight)+"吨" , res.vehicleWidth , res.vehicleType , res.goodsType], seperate: " | ")
            let model = ResourceHallUIModel(start: res.startProvince + res.startCity,
                                            end: res.endProvince + res.endCity,
                                            truckInfo: truckInfo,
                                            goodsInfo: goodsInfo,
                                            isSelf: true,
                                            company: res.companyName,
                                            isAttention: res.shipperCode.count > 0,
                                            unitPrice: res.dealUnitPrice,
                                            reportNum: res.offerNumber)
            return model
        }
        self.refresh(items: items)
    }
    
    override func tapItemAtIndex(index: Int) {
        self.toResouceDetail()
    }
    
    override func toOfferAtIndex(index: Int) {
        self.toResouceDetail()
    }
}
