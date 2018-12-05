//
//  WayBillCommentVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/19.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

struct WaybillCommitModel {
    var logicScore:Float = 0
    var serviceScore:Float = 0
    var comment:String = ""
}

class WayBillCommentVC: BaseVC  {

    @IBOutlet weak var tableView: UITableView!
    private var pageInfo:TransactionInformation?
    
    public var hallId:String?
    
    // 提交信息
    private var commitModel:WaybillCommitModel = WaybillCommitModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadDetailData(hallId: self.hallId!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func registerCells() -> Void {
        self.tableView.register(UINib.init(nibName: "\(WayBillCommentCell.self)", bundle: nil), forCellReuseIdentifier: "\(WayBillCommentCell.self)")
        self.tableView.register(UINib.init(nibName: "\(WayBillToCommentCell.self)", bundle: nil), forCellReuseIdentifier: "\(WayBillToCommentCell.self)")
    }
}

extension WayBillCommentVC {
    
    func toCommit() -> Void {
        var evaluate = ZbnEvaluateVo()
        evaluate.evaluateTo = 1
        evaluate.transportNo = self.pageInfo?.transportNo ?? ""
        evaluate.logisticsServicesScore = Int(self.commitModel.logicScore)
        evaluate.serviceAttitudeScore = Int(self.commitModel.serviceScore)
        evaluate.commonts = self.commitModel.comment
        if evaluate.logisticsServicesScore == 0 {
            self.showWarn(warn: "请评价物流服务", complete: nil)
            return
        }
        if evaluate.serviceAttitudeScore == 0 {
            self.showWarn(warn: "请评价服务态度", complete: nil)
            return
        }
        self.showLoading()
        BaseApi.request(target: API.createEvaluate(evaluate), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: "评价成功", complete: {
                    self?.pop(toRootViewControllerAnimation: true)
                })
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}

extension WayBillCommentVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(WayBillCommentCell.self)") as! WayBillCommentCell
            let truckInfo = Util.contact(strs: [self.pageInfo?.vehicleLength ?? "" , self.pageInfo?.vehicleWidth ?? "" , self.pageInfo?.vehicleType ?? "", self.pageInfo?.vehicleNo ?? ""], seperate: " | ")
            cell.showDealInfo(unit: self.pageInfo?.dealUnitPrice,
                              amount: self.pageInfo?.dealTotalPrice,
                              cyName: self.pageInfo?.carrierName,
                              driver: self.pageInfo?.driverName,
                              truckInfo: truckInfo,
                              dealTime: (self.pageInfo?.dealTime) ?? 0 / 1000,
                              offerTime: (self.pageInfo?.publishTime ?? 0) / 1000)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WayBillToCommentCell.self)") as! WayBillToCommentCell
        cell.showInfo(logicScore: commitModel.logicScore, serviceScore: commitModel.serviceScore, comment: commitModel.comment)
        cell.commentClosure  = {[weak self] (logicScore , serviceScore , comment) in
            self?.commitModel.logicScore = logicScore
            self?.commitModel.serviceScore = serviceScore
            self?.commitModel.comment = comment ?? ""
        }
        cell.commitClosure = {[weak self] in
            self?.toCommit()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}


extension WayBillCommentVC {
    func loadDetailData(hallId:String) -> Void {
        self.showLoading()
        BaseApi.request(target: API.queryTransportDetail(hallId), type: BaseResponseModel<TransactionInformation>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.pageInfo = data.data
                self?.tableView.reloadData()
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}
