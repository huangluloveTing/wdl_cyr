//
//  AuthenEnterpriseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class AuthenEnterpriseVC: NormalBaseVC {
    
    @IBOutlet weak var enterpriseNameTextField: UITextField!
    @IBOutlet weak var enterpriseSummerTextField: UITextField!
    @IBOutlet weak var legalNameTextField: UITextField!
    @IBOutlet weak var IDCardTextField: UITextField!
    @IBOutlet weak var businesslicenseLabel: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func currentConfig() {
        self.enterpriseNameTextField.titleTextField(title: "企业名称")
        self.enterpriseSummerTextField.titleTextField(title: "企业简称")
        self.legalNameTextField.titleTextField(title: "法人姓名")
        self.IDCardTextField.titleTextField(title: "身份证号码")
        self.businesslicenseLabel.titleTextField(title: "营业执照")
        self.addressTextField.titleTextField(title: "联系地址")
        self.mobileTextField.titleTextField(title: "联系电话")
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.5, radius: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
