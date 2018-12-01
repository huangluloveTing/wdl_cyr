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
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailUI()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendBackMoney(_ sender: Any) {
        self.toSendBackMoneyHandle()
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
        return 3
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
            self.toTransactionDetails()
        }
    }
}

// handles
extension WalletVC {
    
    //MARK: 退还保证金
    func toSendBackMoneyHandle() -> Void {
        
    }
    
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
}
