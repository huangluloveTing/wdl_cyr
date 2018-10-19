//
//  Resource_PriceInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class Resource_PriceInfoCell: BaseCell {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension Resource_PriceInfoCell {
    func showInfo(unit:Float? , total:Float?) -> Void {
        self.startLabel.text = Util.floatPoint(num: 2, floatValue: unit ?? 0) + "元/吨"
        self.endLabel.text = Util.floatPoint(num: 2, floatValue: total ?? 0) + "元"
    }
}
