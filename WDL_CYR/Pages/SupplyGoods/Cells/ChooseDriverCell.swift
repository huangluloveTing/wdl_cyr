//
//  ChooseDriverCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/22.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ChooseDriverCell: BaseCell {
    
    typealias ChooseDriverClosure = () -> ()
    
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var idCardLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    public var chooseClosure : ChooseDriverClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkHandle(_ sender: Any) {
        if let closure = self.chooseClosure {
            closure()
        }
    }
}

extension ChooseDriverCell {
    func showInfo(driverName:String? , idNo:String? , phone:String? , checked:Bool) -> Void {
        self.driverNameLabel.text = driverName
        self.idCardLabel.text = idNo
        self.phoneLabel.text = phone
        self.checkButton.isSelected = checked
    }
}
