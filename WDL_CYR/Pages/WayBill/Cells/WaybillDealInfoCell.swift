//
//  WaybillDealInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillDealInfoCell: BaseCell {
    
    @IBOutlet weak var dealTimeLabel: UILabel!      //  成交时间
    @IBOutlet weak var unitPriceLabel: UILabel!     //  成交单价
    @IBOutlet weak var totalPriceLabel: UILabel!    //  成交t总额
    @IBOutlet weak var serviceFeeLabel: UILabel!    //  服务费
    @IBOutlet weak var transportCapacityLabel: UILabel! //  承运运输量
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WaybillDealInfoCell {
    
    func showInfo(time:TimeInterval? ,
                  unit:Float? ,
                  total:Float? ,
                  serviceFee:Float? ,
                  capacity:Float?) -> Void {
        self.dealTimeLabel.text = Util.dateFormatter(date: time ?? 0, formatter: "yyyy-MM-dd HH:mm:ss")
        self.unitPriceLabel.text = Util.floatPoint(num: 2, floatValue: unit ?? 0) + "元/吨"
        self.totalPriceLabel.text = Util.floatPoint(num: 2, floatValue: total ?? 0) + "元"
        self.serviceFeeLabel.text = Util.floatPoint(num: 2, floatValue: serviceFee ?? 0) + "元"
        self.transportCapacityLabel.text = Util.floatPoint(num: 3, floatValue: capacity ?? 0) + "吨"
    }
    
}
