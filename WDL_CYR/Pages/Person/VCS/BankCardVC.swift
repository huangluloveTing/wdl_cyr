//
//  BankCardVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/3.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class BankCardVC: NormalBaseVC {
    //银行名
    @IBOutlet weak var bankNameLab: UILabel!
    //卡号
    @IBOutlet weak var numberLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //修改
    @IBAction func modifyClick(_ sender: UIButton) {
        let vc = ModifyBankSetVC()
        push(vc: vc, title: "银行卡设置")
    }
}
