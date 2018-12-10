//
//  TransactionDetailsVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransactionDetailsVC: NormalBaseVC {
    
    let messageStatus:[String] = ["全部","服务费扣除","服务费退回","违约金扣除",
                                  "违约金退回","充值","平台充值","保证金冻结",
                                  "保证金释放","退还保证金"]
    
    @IBOutlet weak var dropView: DropHintView!
    private var qeury = ZbnCashFlow()
    private var timeChooseView:DropInputDateView {
      return startAndEndTimeChooseViewGenerate()
    }
    private var statusView:GoodsSupplyStatusDropView {
         return statusDropViewGenerate(statusTitles: messageStatus)
    }
    
    @IBOutlet weak var tableView: UITableView!
    //数组
    private var hallLists:[ZbnCashFlow] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        //交易明细数据请求
        self.loadDealDetailRequest()
    }
    
    override func currentConfig() {
        toConfigDropView(dropView: dropView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func timeChooseHandle(startTime: TimeInterval?, endTime: TimeInterval?, tapSure sure: Bool) {
        if sure == true {
            self.qeury.startTime = startTime
            self.qeury.endTime = endTime
        } else {
            self.qeury.startTime = nil
            self.qeury.endTime = nil
        }
        self.tableView.beginRefresh()
        self.dropView.hiddenDropView()
    }
    
    override func statusChooseHandle(index: Int) {
//      flowType   1=充值 2=退钱 3=信息费扣除 4=信息费退回 5=违约金扣除 6=违约金退回 7=保证金扣除 8=保证金退回 9=保证金释放 10=平台充值 ,
//        ["全部","服务费扣除","服务费退回","违约金扣除",
//         "违约金退回","充值","平台充值","保证金冻结",
//         "保证金释放","退还保证金"]
        if index == 0 {
            self.qeury.flowType = nil
        }
        if index == 1 {
            self.qeury.flowType = 3
        }
        if index == 2 {
            self.qeury.flowType = 4
        }
        if index == 3 {
            self.qeury.flowType = 5
        }
        if index == 4 {
            self.qeury.flowType = 6
        }
        if index == 5 {
            self.qeury.flowType = 1
        }
        if index == 6 {
            self.qeury.flowType = 10
        }
        if index == 7 {
            self.qeury.flowType = 7
        }
        if index == 8 {
            self.qeury.flowType = 9
        }
        if index == 9 {
            self.qeury.flowType = 8
        }
        self.tableView.beginRefresh()
        self.dropView.hiddenDropView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: config tableView
extension TransactionDetailsVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerForNibCell(className: TransactionDetailsCell.self, for: self.tableView)
        self.fullSeperate(for: self.tableView)
        tableView.tableFooterView = UIView()
        tableView.pullRefresh()
        tableView.upRefresh()
        tableView.initEstmatedHeights()
        tableView.refreshAndLoadState().asObservable()
            .subscribe(onNext: { [weak self](state) in
                if state == .Refresh {
                    self?.tableView.removeCacheHeights()
                    self?.qeury.pageSize = 20
                } else {
                    self?.qeury.pageSize += 20
                }
                self?.loadDealDetailRequest()
            })
            .disposed(by: dispose)
    }
}

extension TransactionDetailsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hallLists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(className: TransactionDetailsCell.self, for: tableView)
        let info = self.hallLists[indexPath.row]
        //流水类型
        let reason = self.detailTypeText(flowType: info.flowType ?? 0)
        let time = info.createTime ?? 0
        //右侧的金额
        let money = info.flowMoney
        let remark = info.remark ?? ""
        let wayBillNo = info.transportNo ?? ""
        let account =  info.carrierName ?? ""
        let freeze = info.frozenMoney ?? 0
        let balance = info.balance ?? 0 //余额
        let payStatus = self.payTypeText(payType: info.flowStatus ?? 0, cell: cell)//支付状态
        //只有类型是充值，状态是支付成功才可以显示退款
        if info.flowType == 1 && info.flowStatus == 1{
            cell.returnMoney.isHidden = false
        }else{
            cell.returnMoney.isHidden = true
        }
        
        cell.showInfo(reason: reason, time: time, money: money, remark: remark, waybillNo: wayBillNo, account: account, freeze: freeze,  flowStatus: payStatus, balance: balance)
        //点击退款
        cell.buttonClosure = {[weak self] in
            self?.toSendBackMoneyHandle(accountInfo: info)
        }
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightForRow(at: indexPath)
    }
}
//MARK: - loadData
extension TransactionDetailsVC {
    //交易明细数据请求
    func loadDealDetailRequest(){
        //配置参数
        self.showLoading()
        BaseApi.request(target: API.dealDetail(self.qeury), type: BaseResponseModel<PageInfo<ZbnCashFlow>>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.tableView.endRefresh()
                self?.configNetDataToUI(lists: data.data?.list ?? [])
                self?.tableView.reloadData()
                self?.tableView.tableResultHandle(currentListCount: data.data?.list?.count,
                                                  total: data.data?.total)
            },onError: {[weak self] (error) in
                self?.tableView.endRefresh()
                self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }

    // 根据获取数据,组装列表
    func configNetDataToUI(lists:[ZbnCashFlow]) -> Void {
        // msgType (integer): 消息类型 1=系统消息 2=报价消息 3=运单消息 ,
        self.hallLists = lists
        self.tableView.reloadData()
    }
    
    
}


//MARK: - cellUI设置
extension TransactionDetailsVC {
    //支付状态(integer):0=支付失败 1=支付成功  2 - 支付中  3-取消充值
    func payTypeText(payType: Int, cell: TransactionDetailsCell) -> String{
        
        switch payType {
        case 0:
            cell.payStatusLabel.textColor = UIColor.red
            return "支付失败"
        case 1:
            cell.payStatusLabel.textColor = UIColor(hex: "06C06F")
            return "支付成功"
        case 2:
            cell.payStatusLabel.textColor = UIColor.lightGray
            return "支付中"
        case 3:
            cell.payStatusLabel.textColor = UIColor(hex: "7695Cf")
            return "取消充值"
            
        default:
            return ""
        }
    }
    
    //获取流水类型
    //类型 1=充值 2=退钱 3=信息费扣除 4=信息费退回 5=违约金扣除 6=违约金退回 7=保证金扣除 8=保证金退回 9=保证金释放 10=平台充值
    func detailTypeText(flowType: Int) -> String{
        switch flowType {
        case 1:
            return "充值"
        case 2:
            return "退钱"
        case 3:
            return "信息费扣除"
        case 4:
            return "信息费退回"
        case 5:
            return "违约金扣除"
        case 6:
            return "违约金退回"
        case 7:
            return "保证金扣除"
        case 8:
            return "保证金退回"
        case 9:
            return "保证金释放"
        case 10:
            return "平台充值"
        default:
            return ""
        }
    }
}


//MARK: - drop
extension TransactionDetailsVC : DropHintViewDataSource {
    func toConfigDropView(dropView:DropHintView) -> Void {
        dropView.dataSource = self
        dropView.zt_width = IPHONE_WIDTH
        dropView.zt_height = IPHONE_HEIGHT
        dropView.tabTitles(titles: ["交易时间","交易类型"])
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        if index == 0 {
            return timeChooseView
        } else {
            return self.statusView
        }
    }
}

//MARK: - refresh
extension TransactionDetailsVC {
    
    //MARK: 退回可用金额
    func toSendBackMoneyHandle(accountInfo:ZbnCashFlow) -> Void {
        let returnVC = ReturnMoneyVC()
        returnVC.bondnInfo = accountInfo
        self.pushToVC(vc: returnVC, title: "退款可用余额")
    }
    
}
