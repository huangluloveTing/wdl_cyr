//
//  Offer_NotDoneCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class Offer_NotDoneCell: BaseCell {

    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var posibleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension Offer_NotDoneCell {
    func showInfo(info:OfferUIModel?) -> Void {
        self.posibleLabel.text = info?.possible
        self.unitLabel.text = Util.floatPoint(num: 2, floatValue: info?.unitPrice ?? 0)
        self.totalLabel.text = Util.floatPoint(num: 2, floatValue: info?.totalPrice ?? 0)
        self.startLabel.text = info?.start
        self.endLabel.text = info?.end
        self.truckInfoLabel.text = info?.truckInfo
        self.goodsInfoLabel.text = info?.goodsInfo
        self.typeLabel.text = (info?.isSelf ?? false) ? "【自营】" : ""
        self.companyLabel.text = info?.company
        self.attentionButton.isSelected = info?.isAttention ?? false
        self.offerStatusStyle(status: info?.reportStatus, to: self.statusLabel)
        //公司头像
        self.toAddImageForImageView(imageUrl: info?.avatorURL, imageView: self.avatorImageView)
    }
}
