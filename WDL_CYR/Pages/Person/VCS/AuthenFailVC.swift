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
        
//        self.rejectLabel.text = "驳回原因：" + (WDLCoreManager.shared().userInfo?.authenticationMsg ?? "")
         self.rejectLabel.text = "驳回原因：" + (WDLCoreManager.shared().userInfo?.remark ?? "")
    }
    
    override func currentConfig() {
        self.commitAginButton.addBorder(color: nil, width: 0, radius: 4)
    }
    //重新提交
    @IBAction func reSummitClick(_ sender: UIButton) {
        let info = WDLCoreManager.shared().userInfo
        if info?.carrierType == 1 {
            //1.个人
            let autheVC = AuthenIndividualInfoVC()
            autheVC.zbnCarrierInfo = info
            self.pushToVC(vc: autheVC, title: "我的认证")
        }else{
            //2.企业
            let autheVC = AuthenEnterpriseVC()
            autheVC.zbnCarrierInfo = info
            self.pushToVC(vc: autheVC, title: "我的认证")
        }
    
    }

 
}
