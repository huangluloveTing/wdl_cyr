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
    //数组
    private var hallLists:[ZbnCashFlow] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        //交易明细数据请求
        self.loadDealDetailRequest()
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
            self?.toSendBackMoneyHandle()
        }
        return cell
    }
  
}
//MARK: - loadData
extension TransactionDetailsVC {
    //交易明细数据请求
    func loadDealDetailRequest(){
        //配置参数
        self.showLoading()
        var queryBean = ZbnCashFlow()
        
        BaseApi.request(target: API.dealDetail(queryBean), type: BaseResponseModel<PageInfo<ZbnCashFlow>>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.configNetDataToUI(lists: data.data?.list ?? [])
                self?.tableView.reloadData()
                self?.showSuccess()
                },onError: {[weak self] (error) in
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
    
    //MARK: 退回可用金额
    func toSendBackMoneyHandle() -> Void {
        let returnVC = ReturnMoneyVC()
//        let accountInfo =  self.bondnInfo
//        returnVC.bondnInfo = accountInfo
        self.pushToVC(vc: returnVC, title: "退款可用余额")
    }
    
}
