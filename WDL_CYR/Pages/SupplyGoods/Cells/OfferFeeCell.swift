//
//  OfferFeeCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/19.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class OfferFeeCell: BaseCell {

    @IBOutlet weak var myBalanceLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OfferFeeCell {
    func showFee(serviceFee:Float , balance:Float) -> Void {
        self.serviceFeeLabel.text = Util.floatPoint(num: 2, floatValue: serviceFee)
        self.myBalanceLabel.text = Util.floatPoint(num: 2, floatValue: balance) + "元"
    }
}
