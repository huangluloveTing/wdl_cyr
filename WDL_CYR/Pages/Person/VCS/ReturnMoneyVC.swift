//
//  ReturnMoneyVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/4.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class ReturnMoneyVC: NormalBaseVC {
    
    //充值明细的数据模型
    var bondnInfo:ZbnCashFlow?

    //输入退款金额
    @IBOutlet weak var moneyFeild: UITextField!

    //确认按钮
    @IBOutlet weak var sureBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.sureBtn.addBorder(color: nil, radius: 22)

    }


    
    //确认
    @IBAction func sureClick(_ sender: UIButton) {
        
        if self.moneyFeild.text?.length == 0{
            showFail(fail: "请输入退款金额", complete: nil)
            return
        }
        //余额
        let balance: Float = self.bondnInfo?.balance ?? 0
        //支付的金额
        let flowMoney: Float = self.bondnInfo?.flowMoney ?? 0
        let inputM: Float = Float(self.moneyFeild.text!) ?? 0
        if inputM > balance || inputM > flowMoney{
            showFail(fail: "输入的金额不能大于余额和充值的金额", complete: nil)
            return
        }
        //添加用户输入的金额
        self.bondnInfo?.money = self.moneyFeild.text
        BaseApi.request(target: API.returnMoney(self.bondnInfo!), type: BaseResponseModel<Any>.self)
            .retry(2)
            .subscribe(onNext: { [weak self](data) in
                print("退款:\(data)")
//                self?.showSuccess(success: data.message, complete: {
//                    self?.pop(animated: true)
//                })
                
                
                guard data.data != nil else{
                    self?.showFail(fail: "暂时无法获取退款页面，请稍后再试", complete: nil)
                    return
                }
                self?.showSuccess(success: nil)
                let paymentVC = PayHtmlVC()
                //                let dic = data.data as? Dictionary<String, Any>
                //                paymentVC.htmlString = dic?["data"] as? String
                paymentVC.htmlString = data.data! as? String
                self?.pushToVC(vc: paymentVC, title: "退款")
                },onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
        
    }
    
}


