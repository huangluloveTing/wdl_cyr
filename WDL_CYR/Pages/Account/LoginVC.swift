//
//  WDLLoginVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/23.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: BaseVC {
    
    let loginVM = LoginVModel(username: PublishSubject<String>(), passwd: PublishSubject<String>())
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passworldTextField: UITextField!
    
    
    //MARK: config
    override func currentConfig() {
        self.fd_prefersNavigationBarHidden = true
        self.loginButton.addBorder(color: nil)
        self.registerButton.addBorder(color: UIColor(hex: COLOR_BORDER), width: 1)
    }
    
    override func bindViewModel() {
        self.registerButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.toRegisterVC(title: nil)
            })
            .disposed(by: dispose)
        
        self.loginButton.rx.tap.asObservable()
            .filter({ () -> Bool in
                if self.phoneTextField.text?.count == 0 && self.passworldTextField.text?.count == 0 {
                    self.showWarn(warn: "请输入手机号或者密码", complete: nil)
                    return false
                    
                }
                return true
            })
            .flatMap({ () ->  Observable<String> in
                return self.loginHandle()
            })
            .subscribe(onNext: { (valid) in
                self.toMainVC()
            })
            .disposed(by: dispose)
        
        self.phoneTextField.rx.text.orEmpty
            .bind(to: self.loginVM.username)
            .disposed(by: dispose)
        
        self.passworldTextField.rx.text.orEmpty
            .bind(to: self.loginVM.passwd)
            .disposed(by: dispose)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //忘记密码
    @IBAction func forgetPwdAction(_ sender: Any) {
        self.toForgetPwdVC()
    }

    // 点击我是承运人
    @IBAction func toCYRAction(_ sender: Any) {
        let container = ContainerVC()
        self.push(vc: container, title: nil)
    }
    
    // 点击联系客服
    @IBAction func toLinkCustomerServiceAction(_ sender: Any) {
        self.toLinkKF()
    }
}

extension LoginVC {
    
    func loginHandle() -> Observable<String> {
        self.showLoading()
        return Observable<String>.create({ (obser) -> Disposable in
            return BaseApi.request(target: API.login(self.phoneTextField.text ?? "", self.passworldTextField.text ?? ""), type: BaseResponseModel<String>.self)
                    .subscribe(onNext: { (model) in
                        self.showSuccess()
                        print("respone = \(model.toJSON() ?? ["s":""])")
                        WDLCoreManager.shared().token = model.data
                        obser.onNext(model.data ?? "")
                        obser.onCompleted()
                    },
                               onError:{(error) in
                        self.showFail(fail: error.localizedDescription, complete: nil)
                    })
        })
    }
}

struct LoginVModel {
    var username:PublishSubject<String>
    var passwd:PublishSubject<String>
}
