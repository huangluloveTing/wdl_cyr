//
//  RechargeInlineVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/4.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

// 在线充值
class RechargeInlineVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNaviSelectTitles(titles: ["在线充值","线下充值"])
        self.configTabView()
        self.registerAllCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func tapNaviHandler(index: Int) {
        
    }
}

extension RechargeInlineVC {
    
    func configTabView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    func registerAllCells() -> Void {
        self.registerCell(nibName: "\(InLineMoneyCell.self)", for: self.tableView)
    }
}

//Handles
extension RechargeInlineVC {
    func toRecharge(num:Float) -> Void {
        print("recharge money : " + String(num))
        let paymentVC = PaymentTypeVC()
        self.push(vc: paymentVC, title: "支付方式")
    }
}

extension RechargeInlineVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(InLineMoneyCell.self)") as! InLineMoneyCell
        cell.rechargeClosure = {[weak self] (selectMoney , inputMoney) in
            self?.toRecharge(num: inputMoney ?? selectMoney)
        }
        return cell
    }
}


