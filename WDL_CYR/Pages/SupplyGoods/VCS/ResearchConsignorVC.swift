//
//  ResearchConsignorVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/17.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ResearchConsignorVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var consignors:[ConsignorFollowShipper]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addResearchBar()
        self.configTableView()
        self.registerAllComponents()
    }

    // 搜索框输入内容
    override func searchBarInput(search: String) {
        self.searchConsignors(input: search)
    }
}

// search bar
extension ResearchConsignorVC {
    func addResearchBar() -> Void {
        self.removeRightBarButton()
        self.addNaviHeader(placeholer: "请输入企业名称、手机号等搜索添加")
        self.addRightBarbuttonItem(withTitle: "取消")
    }
}

// tableView
extension ResearchConsignorVC {
    
    //配置tableView
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.initDisplay()
        self.emptyTitle(title: "该货主不存在", to: self.tableView)
    }
    
    func registerAllComponents() -> Void {
        self.tableView.registerCell(nib: ConsignorResearchCell.self)
    }
    
}


// 搜索 未关注的托运人
extension ResearchConsignorVC {
    func searchConsignors(input:String) -> Void {
        BaseApi.request(target: API.selectZbnConsignor(input), type: BaseResponseModel<[ConsignorFollowShipper]>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.consignors = data.data ?? []
                self?.toRenderTableView()
            })
            .disposed(by: dispose)
    }
    
    func toRenderTableView() {
        self.tableView.reloadData()
    }
}


extension ResearchConsignorVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.consignors?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: ConsignorResearchCell.self)
        let consignor = self.consignors![indexPath.row]
        cell.showInfo(logoImage: consignor.logParh, companyName: consignor.consignorName)
        cell.tapAttentionClosure = {[weak self]() in
            print("tap attention + ")
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.loadNibView(nibName: ConsignorResearchHeader.self)
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let headerView = tableView.headerView(forSection: section)
//        let height = headerView?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height ?? 40
//        return height
//    }
}
