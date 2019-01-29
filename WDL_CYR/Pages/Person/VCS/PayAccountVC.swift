//
//  PayAccountVC.swift
//  WDL_CYR
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 yinli. All rights reserved.
//  支付账号

import UIKit

class PayAccountVC: NormalBaseVC {

    @IBOutlet weak var inputTextField: UITextField!
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//提交
    @IBAction func applyClick(_ sender: Any) {
        self.showLoading()
        var query = PayAccountModel()
        query.carrierId = WDLCoreManager.shared().userInfo?.id ?? ""
        query.payAccount = self.inputTextField.text ?? ""
        BaseApi.request(target: API.payAccountWallet(query), type: BaseResponseModel<Any>.self)
            .retry(2)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
               
                },onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }

}
