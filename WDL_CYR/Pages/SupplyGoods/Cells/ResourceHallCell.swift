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
    
    //货源编号：id
    @IBOutlet weak var goodCodeId: UILabel!
    //标题
    //参考价
    @IBOutlet weak var canPriceTitleLab: UILabel!
    
    //参考价单位
    @IBOutlet weak var unitTitleLab: UILabel!
    //多少人报价
    @IBOutlet weak var perNumTitleLab: UILabel!
    
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
    
    private var info:ResourceHallUIModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reportButton.addBorder(color: nil, width: 0, radius: 15)
        self.avatorView.addBorder(color: nil, width: 0, radius: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func offerAction(_ sender: Any) {
        if info?.isOffer == true {
            return
        }
        if let closure = self.offerClosure {
            closure()
        }
    }
}

extension ResourceHallCell {
    
    func showInfo(info:ResourceHallUIModel?) -> Void {
        self.info = info
        self.startLabel.text = info?.start
        self.endLabel.text = info?.end
        //货源编号
        self.goodCodeId.text = "货源编号：" +  (info?.id ?? "")
        self.truckDescLabel.text = info?.truckInfo
        self.goodsDescLabel.text = info?.goodsInfo
        self.typeLabel.text = (info?.isSelf ?? false) ? "" : "【自营】"
        
        self.attentionButton.isSelected = info?.isAttention ?? false
        self.unitPriceLabel.text = String(format: "%.f",  info?.refercneceUnitPrice ?? 0)
        self.reportNumLabel.text = String(format: "%d人报价", info?.reportNum ?? 0)
        // 头像
         Util.showImage(imageView: self.avatorView, imageUrl: info?.companyLogo ?? "")
        // 参考价是否可见 1=可见 2=不可见
        if info?.refercnecePriceIsVisable == 1 {
            self.unitPriceLabel.isHidden = false
            canPriceTitleLab.isHidden = false
            unitTitleLab.isHidden = false
            perNumTitleLab.isHidden = false
        }else{
            self.unitPriceLabel.isHidden = true
            canPriceTitleLab.isHidden = true
            unitTitleLab.isHidden = true
            perNumTitleLab.isHidden = true
        }
        //是否报价
        self.reportButton.isSelected = info?.isOffer ?? false
        if info?.isOffer == true {
            //报价
            self.reportButton.backgroundColor = UIColor(hex: "D3D3D3")
            self.tyNameLabel.text = info?.company
        } else {
            //未报价
            self.tyNameLabel.text = "*****公司"
            self.reportButton.backgroundColor = UIColor(hex: "06C06F")
        }
    }
}
