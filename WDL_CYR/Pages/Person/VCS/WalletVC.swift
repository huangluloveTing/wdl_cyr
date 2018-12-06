//
//  WalletVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/4.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let Wallet_Titles = ["交易明细","银行卡设置","修改支付密码"]

class WalletVC: NormalBaseVC {
    //可支配余额
    @IBOutlet weak var amountLabel: UILabel!
    //总金额
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var bondnInfo = WDLCoreManager.shared().bondInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailUI()
        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBondInfo()
        walletAmount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendBackMoney(_ sender: Any) {
//        self.toSendBackMoneyHandle()
    }
}

extension WalletVC {
    
    func initailUI() -> Void {
        self.rechargeButton.addBorder(color: UIColor.white, width: 1, radius: 2)
        self.rechargeButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.toRecharge()
            })
            .disposed(by: dispose)
    }
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension WalletVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = Wallet_Titles[indexPath.row]
        cell?.textLabel?.textColor = UIColor(hex: "333333")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 去交易明细
            self.toTransactionDetails()
        }
        
        if indexPath.row == 1 {
            //银行卡设置
            self.toBankSet()
        }
        if indexPath.row == 2 {
            //修改支付密码
            self.toModifyPassword()
        }
    }
}

// handles
extension WalletVC {
    
    //银行卡设置
    func toBankSet() -> Void {
        let bankVC = BankCardVC()
        self.pushToVC(vc: bankVC, title: "银行卡设置")
        
    }
    //修改支付密码
    func toModifyPassword() -> Void {

        let modifyVC = AddModifyPayPasswordVC()
        self.pushToVC(vc: modifyVC, title: "修改支付密码")
    }
    
    //MARK: 退回可用金额
//    func toSendBackMoneyHandle() -> Void {
//        let returnVC = ReturnMoneyVC()
//        let accountInfo =  self.bondnInfo
//        returnVC.bondnInfo = accountInfo
//        self.pushToVC(vc: returnVC, title: "退款可用余额")
//    }
    
    // 去充值
    func toRecharge() -> Void {
        let rechargeVC = RechargeInlineVC()
        self.pushToVC(vc: rechargeVC, title: nil)
    }
    
    // 去交易明细
    func toTransactionDetails() -> Void {
        let transactionDetailsVC = TransactionDetailsVC()
        self.pushToVC(vc: transactionDetailsVC, title: "交易明细")
    }
    
    // 设置账号余额
    func walletAmount() -> Void {
        //可支配金额
        self.amountLabel.text = Util.floatPoint(num: 2, floatValue: self.bondnInfo?.useableMoney ?? 0)
        //总金额金额
        self.totalLabel.text = Util.floatPoint(num: 2, floatValue: self.bondnInfo?.totalMoney ?? 0)
        
    }
    
    // 获取账号余额信息
    func loadBondInfo() -> Void {
        self.loadCarrierBoundTask().asObservable()
            .retry(5)
            .subscribe(onNext: { (data) in
                WDLCoreManager.shared().bondInfo = data.data
                self.bondnInfo = data.data
                self.walletAmount()
            })
            .disposed(by: dispose)
    }
}
