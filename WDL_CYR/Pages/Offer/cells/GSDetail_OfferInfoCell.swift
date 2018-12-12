//
//  GSDetail_OfferInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetail_OfferInfoCell: BaseCell {
    
    @IBOutlet weak var possibleLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var otherNumLabel: UILabel!
    @IBOutlet weak var otherReportLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension GSDetail_OfferInfoCell {
    
    func showOfferInfo(myOffer:OfferInfoModel , otherOffers:[OfferInfoModel]? , showOffer:Bool = true) -> Void {
        self.possibleLabel.text = myOffer.dealPossible
        self.unitPriceLabel.text = Util.floatPoint(num: 2, floatValue: myOffer.offerUnitPrice)+"元/吨"
        self.totalPriceLabel.text = Util.floatPoint(num: 2, floatValue: myOffer.offerTotalPrice)+"元"
        if otherOffers == nil {
//            self.otherNumLabel.text = ""
//            self.otherReportLabel.text = ""
            return;
        }
//        self.otherNumLabel.text = "已有"+String(otherOffers!.count)+"位承运人报价"
//        self.otherReportLabel.attributedText = self.configOtherReport(offers: otherOffers!)
    }
    
//    // 根据数据，组装其他承运人报价数据
//    func configOtherReport(offers:[OfferInfoModel]) -> NSAttributedString {
//        var info = ""
//        for offer in offers {
//            let name = offer.offerName
//            let unit = offer.offerUnitPrice
//            let total = offer.offerTotalPrice
//            let info_temp = name + "     " + "单价：" + Util.floatPoint(num: 2, floatValue: unit) + "元/吨" + "     " + "总价：" +  Util.floatPoint(num: 2, floatValue: total) + "元" + "\n"
//            info.append(info_temp)
//        }
//        if info.count > 2 {
//            info = String(info.prefix(info.count - 1))
//        }
//        return Util.sepecialText(text: info, lineSpace: 14, font: UIFont.systemFont(ofSize: 12), color: UIColor(hex: "333333"))
//    }
}
