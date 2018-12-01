//
//  Offer_DoneCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class Offer_DoneCell: BaseCell {
    
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var designateLabel: UILabel!
    @IBOutlet weak var avatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension Offer_DoneCell {
    func showInfo(info:OfferUIModel?) -> Void {
        self.unitPriceLabel.text = Util.floatPoint(num: 2, floatValue: info?.unitPrice ?? 0)
        self.totalPriceLabel.text = Util.floatPoint(num: 2, floatValue: info?.totalPrice ?? 0)
        self.startLabel.text = info?.start
        self.endLabel.text = info?.end
        self.truckInfoLabel.text = info?.truckInfo
        self.goodsInfoLabel.text = info?.goodsInfo
        self.toAddImageForImageView(imageUrl: info?.avatorURL, imageView: self.avatorImageView)
        self.typeLabel.text = (info?.isSelf ?? false) ? "【自营】" : ""
        self.companyLabel.text = info?.company
        self.offerDesignateStyle(designate: info?.reportStatus.rawValue, to: self.designateLabel)
    }
}
