//
//  ResourceHallCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ResourceHallCell: BaseCell {
    
    typealias ResourceOfferClosure = () -> ()
    
    @IBOutlet weak var avatorView: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsDescLabel: UILabel!
    @IBOutlet weak var truckDescLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportNumLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var tyNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    public var offerClosure:ResourceOfferClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reportButton.addBorder(color: nil, width: 0, radius: 15)
        self.avatorView.addBorder(color: nil, width: 0, radius: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func offerAction(_ sender: Any) {
        if let closure = self.offerClosure {
            closure()
        }
    }
}

extension ResourceHallCell {
    
    func showInfo(info:ResourceHallUIModel?) -> Void {
        self.startLabel.text = info?.start
        self.endLabel.text = info?.end
        self.truckDescLabel.text = info?.truckInfo
        self.goodsDescLabel.text = info?.goodsInfo
        self.typeLabel.text = (info?.isSelf ?? false) ? "" : "【自营】"
        self.tyNameLabel.text = info?.company
        self.attentionButton.isSelected = info?.isAttention ?? false
        self.unitPriceLabel.text = String(format: "%.f",  info?.unitPrice ?? 0)
        self.reportNumLabel.text = String(format: "%d人报价", info?.reportNum ?? 0)
    }
}
