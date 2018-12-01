//
//  GSDetail_GoodsInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetail_GoodsInfoCell: BaseCell {

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var referenceTotalLabel: UILabel!
    @IBOutlet weak var referenceUnitLabel: UILabel!
    @IBOutlet weak var goodsSummerLabel: UILabel!
    @IBOutlet weak var goodsTypeLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension GSDetail_GoodsInfoCell {
    
    func showGoodsInfo(info:GSInfoModel) -> Void {
        self.gsStatus(status: info.status, to: self.statusLabel)
        self.startLabel.text = info.start
        self.endLabel.text = info.end
        self.loadTimeLabel.text = Util.dateFormatter(date: info.loadTime / 1000, formatter: "yyyy-MM-dd")
        self.goodsNameLabel.text = info.goodsName
        self.goodsTypeLabel.text = info.goodsType
        self.goodsSummerLabel.text = info.goodsSummer
        self.referenceUnitLabel.text = Util.floatPoint(num: 2, floatValue: info.referenceUnitPrice)+"元/吨"
        self.referenceTotalLabel.text = Util.floatPoint(num: 2, floatValue: info.referenceTotalPrice) + "元"
        self.remarkLabel.text = info.remark ?? " "
    }
}

