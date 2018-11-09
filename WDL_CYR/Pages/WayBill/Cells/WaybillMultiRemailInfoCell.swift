//
//  WaybillMultiRemailInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillMultiRemailInfoCell: BaseCell {

    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension WaybillMultiRemailInfoCell {
    func showInfo(total:Float? , remain:Float?) -> Void {
        self.totalWeightLabel.text = "承运总数量:" + Util.floatPoint(num: 0, floatValue: total ?? 0) + "吨"
        self.remainLabel.text = "剩余" + Util.floatPoint(num: 0, floatValue: remain ?? 0) + "吨未配载"
    }
}
