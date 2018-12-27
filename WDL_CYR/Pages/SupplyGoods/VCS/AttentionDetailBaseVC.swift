//
//  AttentionDetailBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

struct AttentionDetailModel {
    
}

class AttentionDetailBaseVC: NormalBaseVC {
    
    private var baseTableView:UITableView?
    private var items:[ResourceHallUIModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.pageTitle()
    }
    
    //MARK: -
    override func callBackForRefresh(param: Any?) {
        
    }
    
    //MARK: 常用接口
    // 对应的title
    func pageTitle() -> String? {return ""}
    // 点击报价
    func toOfferAtIndex(index:Int) {}
    // 点击cell
    func tapItemAtIndex(index:Int) {}
}

// public method
extension AttentionDetailBaseVC {
    func defineTableView(tableView:UITableView) -> Void {
        baseTableView = tableView
        baseTableView?.delegate = self
        baseTableView?.dataSource = self
        self.registerAllCell()
    }
    
    func refresh(items:[ResourceHallUIModel]) -> Void {
        self.items = items
        self.baseTableView?.reloadData()
    }
    
    //MARK: - 报价成功，刷新某个cell，使其不能再报价
    func offerSuccessedIndex(index:Int) -> Void {
        var info = self.items![index]
        info.isOffer = true
        self.items![index] = info
        self.baseTableView?.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
    }
}

// private method
extension AttentionDetailBaseVC {
    // 注册所有的cell
    func registerAllCell() -> Void {
        self.baseTableView?.registerCell(nib: ResourceHallCell.self)
    }
}

extension AttentionDetailBaseVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: ResourceHallCell.self)
        let info = self.items?[indexPath.section]
        cell.showInfo(info: info)
        cell.offerClosure = {[weak self] () in
            self?.toOfferAtIndex(index: indexPath.section)
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapItemAtIndex(index: indexPath.section)
    }
}
