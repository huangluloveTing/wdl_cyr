//
//  AddModifyPayPasswordVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/3.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class AddModifyPayPasswordVC: NormalBaseVC {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var identiferField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var codeBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //下一步
    @IBAction func nextClick(_ sender: UIButton) {
        let vc = ModifyPayPasswordVC()
        push(vc: vc, title: "修改支付密码")
    }
    
    //获取验证码
    @IBAction func getCodeClick(_ sender: UIButton) {
    }
}
