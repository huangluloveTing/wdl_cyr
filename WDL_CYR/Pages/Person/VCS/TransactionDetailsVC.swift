//
//  TransactionDetailsVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransactionDetailsVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: config tableView
extension TransactionDetailsVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerForNibCell(className: TransactionDetailsCell.self, for: self.tableView)
        self.fullSeperate(for: self.tableView)
    }
}

extension TransactionDetailsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(className: TransactionDetailsCell.self, for: tableView)
        return cell
    }
}
//MARK: - loadData
extension TransactionDetailsVC {
//    //交易明细数据请求
//    func loadInfoRequest(pageSize:Int){
//        //配置参数
//        self.showLoading()
////        self.queryBean.pageSize = pageSize
//        BaseApi.request(target: API.getMainMessage(self.queryBean), type: BaseResponseModel<PageInfo<MessageQueryBean>>.self)
//            .retry(2)
//            .subscribe(onNext: { [weak self](data) in
//                self?.tableView.endRefresh()
//                self?.showSuccess(success: nil)
//                self?.configNetDataToUI(lists: data.data?.list ?? [])
//                if (data.data?.list?.count ?? 0) >= (data.data?.total ?? 0) {
//                    self?.tableView.noMore()
//                }
//                },onError: {[weak self] (error) in
//                    self?.showFail(fail: error.localizedDescription)
//            })
//            .disposed(by: dispose)
//    }
//
//    // 根据获取数据,组装列表
//    func configNetDataToUI(lists:[MessageQueryBean]) -> Void {
//        // msgType (integer): 消息类型 1=系统消息 2=报价消息 3=运单消息 ,
//        self.hallLists = lists
//        self.tableView.reloadData()
//    }
}
