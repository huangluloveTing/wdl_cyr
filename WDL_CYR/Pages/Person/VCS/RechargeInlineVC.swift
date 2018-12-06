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
//        self.addNaviSelectTitles(titles: ["在线充值","线下充值"])
        self.addNaviSelectTitles(titles: ["在线充值"])
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
       
        var queryBean = ZbnCashFlow()
        queryBean.flowMoney = num
        BaseApi.request(target: API.rechargeMoney(queryBean), type: BaseResponseModel<Any>.self)
            .retry(2)
            .subscribe(onNext: { [weak self](data) in

                print("充值的网页: \(String(describing: data.data))")
                self?.showSuccess(success: nil)

                let paymentVC = PayHtmlVC()
                paymentVC.htmlString = data.data as? String
                self?.pushToVC(vc: paymentVC, title: "支付")
               
                },onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)

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


