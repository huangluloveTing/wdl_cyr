//
//  WalletMoneyCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/4.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WalletMoneyCell: BaseCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rechargeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rechargeBtn.addBorder(color: UIColor.white, width: 1, radius: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WalletMoneyCell {
    func showAmount(amount:Float) -> Void {
        self.amountLabel.text = Util.floatPoint(num: 2, floatValue: amount)
    }
}
