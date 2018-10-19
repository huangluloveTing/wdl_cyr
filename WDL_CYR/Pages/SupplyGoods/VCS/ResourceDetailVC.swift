//
//  ResourceDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ResourceDetailVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubViews()
        self.registerAllCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bottomButtom(titles: ["我要报价"], targetView: self.tableView) { [weak self](_) in
            self?.toReportPrice()
        }
    }
}

extension ResourceDetailVC {
    //MARK: configTableView
    func configSubViews() -> Void {
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.tableView.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func registerAllCells() -> Void {
        self.registerForNibCell(className: Resource_PriceInfoCell.self, for: tableView)
        self.registerForNibCell(className: Resource_GoodsInfoCell.self, for: tableView)
        self.registerForNibCell(className: Resource_ShipperInfoCell.self, for: tableView)
    }
}

//MARK: Handles
extension ResourceDetailVC {
    
    // 去报价
    func toReportPrice() -> Void {
        let vc = ChooseOfferTypeVC()
        self.push(vc: vc, title: "选择报价类型")
    }
}

extension ResourceDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = self.dequeueReusableCell(className: Resource_PriceInfoCell.self, for: tableView)
            
            return cell
        }
        
        if section == 1 {
            let cell = self.dequeueReusableCell(className: Resource_GoodsInfoCell.self, for: tableView)
            
            return cell
        }
        
        let cell = self.dequeueReusableCell(className: Resource_ShipperInfoCell.self, for: tableView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
