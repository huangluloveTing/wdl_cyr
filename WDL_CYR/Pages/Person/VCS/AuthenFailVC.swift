//
//  AuthenFailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthenFailVC: NormalBaseVC {
    //拒绝原因文本
    @IBOutlet weak var rejectLabel: UILabel!
    //重新提交按钮
    @IBOutlet weak var commitAginButton: UIButton!
    //打电话
    @IBOutlet weak var callButton: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //打电话
       let taps: Observable<Void> = callButton.rx.tap.asObservable()
        taps.subscribe(onNext: {Util.toCallPhone(num: KF_PHONE_NUM) }).disposed(by: disposeBag)
        
        self.rejectLabel.text = "驳回原因：" + (WDLCoreManager.shared().userInfo?.authenticationMsg ?? "")
    }
    
    override func currentConfig() {
        self.commitAginButton.addBorder(color: nil, width: 0, radius: 4)
    }
    
}
