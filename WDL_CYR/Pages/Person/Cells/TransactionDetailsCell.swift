//
//  TransactionDetailsCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransactionDetailsCell: BaseCell {
    //流水类型
    @IBOutlet weak var transactionReasonLabel: UILabel!
    //时间
    @IBOutlet weak var transactionTimeLabel: UILabel!
    //右侧的金额
    @IBOutlet weak var transactionMoneyLabel: UILabel!
    //备注
    @IBOutlet weak var remarkLabel: UILabel!
    //运单号
    @IBOutlet weak var waybillNoLabel: UILabel!
   //账户
    @IBOutlet weak var accountLabel: UILabel!
    //冻结资金
    @IBOutlet weak var freezeMoneyLabel: UILabel!
    //余额
    @IBOutlet weak var balanceLabel: UILabel!
    //支付状态： var flowStatus : Int?  //(integer):0=支付失败 1=支付成功  2 - 支付中  3-取消充值
    @IBOutlet weak var payStatusLabel: UILabel!
    
    //退款
    @IBOutlet weak var returnMoney: UIButton!
    
    typealias ButtonClosure = () ->()
    public var buttonClosure : ButtonClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //退款按钮
    @IBAction func returnClick(_ sender: UIButton) {
        if let closure = self.buttonClosure{
            closure()
        }
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
                  flowStatus:String? ,
                  balance:Float?) -> Void {
        self.transactionReasonLabel.text = reason
        self.transactionTimeLabel.text = Util.dateFormatter(date: (time ?? 0)/1000 , formatter: "yyyy-MM-dd HH:mm:ss")
        self.transactionMoneyLabel.text = Util.floatPoint(num: 2, floatValue: money ?? 0) + "元"
        self.balanceLabel.text = Util.floatPoint(num: 2, floatValue: balance ?? 0) + "元"
        self.accountLabel.text = account
        self.freezeMoneyLabel.text = Util.floatPoint(num: 2, floatValue: freeze ?? 0) + "元"
        self.waybillNoLabel.text = waybillNo
        self.remarkLabel.text = remark ?? " "
        self.payStatusLabel.text = flowStatus
    }
}
