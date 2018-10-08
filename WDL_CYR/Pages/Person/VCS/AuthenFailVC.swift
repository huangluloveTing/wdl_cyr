//
//  AuthenFailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class AuthenFailVC: NormalBaseVC {

    @IBOutlet weak var rejectLabel: UILabel!
    @IBOutlet weak var commitAginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func currentConfig() {
        self.commitAginButton.addBorder(color: nil, width: 0, radius: 4)
    }

}
