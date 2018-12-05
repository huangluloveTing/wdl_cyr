//
//  ReturnMoneyVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/4.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class ReturnMoneyVC: NormalBaseVC {
    
    //金额账户数据
    var bondnInfo:ZbnBondInfo?
    
    //可退金额
    @IBOutlet weak var returnMoneyLab: UILabel!
    //账户人
    @IBOutlet weak var accountLab: UILabel!
    //输入退款金额
    @IBOutlet weak var moneyFeild: UITextField!
    //全部退回按钮
    @IBOutlet weak var allReturnBtn: UIButton!
    //确认按钮
    @IBOutlet weak var sureBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.allReturnBtn.addBorder(color: nil, radius: 16)
        self.sureBtn.addBorder(color: nil, radius: 22)
      
        
        //可支配金额
        self.returnMoneyLab.text = Util.floatPoint(num: 2, floatValue: self.bondnInfo?.useableMoney ?? 0) + "元"
        //账户人
        self.accountLab.text = self.bondnInfo?.bankAccount ?? ""
    }

    //全部退回
    @IBAction func allReturnClick(_ sender: UIButton) {
        self.moneyFeild.text = Util.floatPoint(num: 2, floatValue: self.bondnInfo?.useableMoney ?? 0)
    }
    
    //确认
    @IBAction func sureClick(_ sender: UIButton) {
        
        if self.moneyFeild.text?.length == 0{
            showFail(fail: "请输入退款金额", complete: nil)
            return
        }
        
        BaseApi.request(target: API.returnMoney(self.moneyFeild.text!), type: BaseResponseModel<Any>.self)
            .retry(2)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop(animated: true)
                })
                },onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
        
    }
    
}


