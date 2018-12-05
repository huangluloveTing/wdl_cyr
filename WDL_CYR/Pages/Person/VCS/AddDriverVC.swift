//
//  AddDriverVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class AddDriverVC: NormalBaseVC {

    @IBOutlet weak var phoneInputView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func nextHandle(_ sender: Any) {
        let phone = phoneInputView.text
        if Util.isPhoneNum(num: phone) {
            toInviteResultPage(phone: phone ?? "")
        } else {
            self.showWarn(warn: "请输入正确的手机号码", complete: nil)
        }
    }
    
    func toInviteResultPage(phone:String) -> Void {
        let result = InviteDriverResultVC()
        result.driverPhone = phone
        self.pushToVC(vc: result, title: "添加驾驶员")
    }
}
