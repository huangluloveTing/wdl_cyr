//
//  TransactionDetailsCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransactionDetailsCell: BaseCell {
    
    @IBOutlet weak var transactionReasonLabel: UILabel!
    @IBOutlet weak var transactionTimeLabel: UILabel!
    @IBOutlet weak var transactionMoneyLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var waybillNoLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var freezeMoneyLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TransactionDetailsCell {
    func showInfo(reason:String? ,
                  time:TimeInterval? ,
                  money:Float? ,
                  remark:String? ,
                  waybillNo:String? ,
                  account:String? ,
                  freeze:Float? ,
                  balance:Float?) -> Void {
        self.transactionReasonLabel.text = reason
        self.transactionTimeLabel.text = Util.dateFormatter(date: time ?? 0, formatter: "yyyy-MM-dd HH:mm:ss")
        self.transactionMoneyLabel.text = Util.floatPoint(num: 2, floatValue: money ?? 0) + "元"
        self.balanceLabel.text = Util.floatPoint(num: 2, floatValue: balance ?? 0) + "元"
        self.accountLabel.text = account
        self.freezeMoneyLabel.text = Util.floatPoint(num: 2, floatValue: freeze ?? 0) + "元"
        self.waybillNoLabel.text = waybillNo
        self.remarkLabel.text = remark ?? " "
    }
}
