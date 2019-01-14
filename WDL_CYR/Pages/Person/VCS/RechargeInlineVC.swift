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
    private var indicatorMoneyLab: UILabel?//提示的最低金额
    
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
        self.tableView.separatorStyle = .none
        
        //添加提示
        self.addIndicator()
        
        //请求提示数据
        self.getIndicator()
    }
    func addIndicator(){
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 60));
        footerView.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 0, width: IPHONE_WIDTH - 60, height: 60)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.orange
        label.font = UIFont.systemFont(ofSize: 15)
        footerView.addSubview(label)
        self.indicatorMoneyLab = label
        self.tableView.tableFooterView = footerView
        
        
    }
    
    func registerAllCells() -> Void {
        self.registerCell(nibName: "\(InLineMoneyCell.self)", for: self.tableView)
    }
}

//Handles
extension RechargeInlineVC {
    func toRecharge(num:Float) -> Void {
       
        var queryBean = ZbnCashFlow()
//        queryBean.flowMoney = num
        let numString = String(format: "%.2lf", num)
         queryBean.money = numString
        BaseApi.request(target: API.rechargeMoney(queryBean), type: BaseResponseModel<Any
            >.self)
            .retry(2)
            .subscribe(onNext: { [weak self](data) in

                print("充值的网页: \(String(describing: data.data))")
                
                guard data.data != nil else{
                   self?.showFail(fail: "暂时无法获取充值页面，请稍后再试", complete: nil)
                    return
                }
                self?.showSuccess(success: nil)
                let paymentVC = PayHtmlVC()
//                let dic = data.data as? Dictionary<String, Any>
//                paymentVC.htmlString = dic?["data"] as? String
                paymentVC.htmlString = data.data! as? String
                self?.pushToVC(vc: paymentVC, title: "支付")
               
                },onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)

    }
    
    //获取提示语的信息内容
    func getIndicator() -> Void {


        BaseApi.request(target: API.getIndicatorMoney(), type: BaseResponseModel<Any
            >.self)
            .subscribe(onNext: { [weak self](data) in

                let money = data.data as? Float
                
                guard money != nil else{
                    self?.indicatorMoneyLab?.text = "根据您的认证信息：您最低充值金额为0元"
                    return
                }
                self?.indicatorMoneyLab?.text = "根据您的认证信息：您最低充值金额为\(String(describing: money!))元"
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


