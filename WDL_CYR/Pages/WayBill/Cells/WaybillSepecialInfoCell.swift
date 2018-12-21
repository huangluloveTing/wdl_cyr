//
//  WaybillSepecialInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WaybillSepecialInfoCell: WaybillBaseCell {
    
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatorImageView: UIImageView!
    //货源编号：id
    @IBOutlet weak var goodCodeId: UILabel!
    @IBOutlet weak var desiginLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var desginDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var twoHandleButton_2: UIButton!
    @IBOutlet weak var twoHandleButton_1: UIButton!
    @IBOutlet weak var oneHandleButton: UIButton!
    @IBOutlet weak var oneHandleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func assembleAction(_ sender: Any) {
        
    }
    
}

extension WaybillSepecialInfoCell {
    //设置cell的值
    func contentInfo(info:WayBillInfoBean?) {
        //货源编号
        self.goodCodeId.text = "货源编号：" + (info?.hallId ?? "")
        self.toAddImageForImageView(imageUrl: info?.companyLogo, imageView: self.avatorImageView)
        self.typeLabel.text = "【自营】运输计划"
        self.startLabel.text = info?.origin
        self.endLabel.text = info?.destination
        let time = Util.dateFormatter(date: Double(info?.loadingTime ?? "0") ?? 0, formatter: "yyyy-MM-dd") + "  装货"
        let weight = (info?.goodsWeight ?? "") + "吨"
        self.goodsInfoLabel.text = Util.contact(strs: [time , weight], seperate: " | ")
        self.timeLabel.text = Util.dateFormatter(date: (info?.createTime ?? 0) / 1000, formatter: "yyyy-MM-dd HH:mm:ss")
    }
}
