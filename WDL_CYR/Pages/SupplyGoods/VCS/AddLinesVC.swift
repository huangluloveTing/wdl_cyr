//
//  AddLinesVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class AddLinesVC: NormalBaseVC {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func bindViewModel() {
        self.startTextField.titleTextField(title: "  始发地  ", indicator: true)
        self.endTextField.titleTextField(title: "  目的地  ", indicator: true)
    }

}
