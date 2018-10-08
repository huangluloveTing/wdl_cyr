//
//  AuthenIndividualInfoVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class AuthenIndividualInfoVC: NormalBaseVC {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var IDCardTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func currentConfig() {
        self.nameTextField.titleTextField(title: "姓名")
        self.mobileTextField.titleTextField(title: "电话")
        self.IDCardTextField.titleTextField(title: "身份证号")
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.5, radius: 2)
    }

    override func bindViewModel() {
        
    }
}
