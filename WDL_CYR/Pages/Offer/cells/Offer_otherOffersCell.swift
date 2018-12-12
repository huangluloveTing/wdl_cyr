//
//  Offer_otherOffersCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/26.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class Offer_otherOffersCell: BaseCell {
    
    @IBOutlet weak var otherNumLabel: UILabel!
    @IBOutlet weak var otherReportLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 根据数据，组装其他承运人报价数据
    private func configOtherReport(offers:[OfferInfoModel]) -> NSAttributedString {
        var info = ""
        for offer in offers {
            let name = offer.offerName
            let unit = offer.offerUnitPrice
            let total = offer.offerTotalPrice
            let info_temp = name + "     " + "单价：" + Util.floatPoint(num: 2, floatValue: unit) + "元/吨" + "     " + "总价：" +  Util.floatPoint(num: 2, floatValue: total) + "元" + "\n"
            info.append(info_temp)
        }
        if info.count > 2 {
            info = String(info.prefix(info.count - 1))
        }
        return Util.sepecialText(text: info, lineSpace: 14, font: UIFont.systemFont(ofSize: 12), color: UIColor(hex: "333333"))
    }
    
    func showOfferInfo(otherOffers:[OfferInfoModel]) -> Void {
        self.otherNumLabel.text = "已有其他"+String(otherOffers.count)+"位承运人报价"
        self.otherReportLabel.attributedText = self.configOtherReport(offers: otherOffers)
    }
}
