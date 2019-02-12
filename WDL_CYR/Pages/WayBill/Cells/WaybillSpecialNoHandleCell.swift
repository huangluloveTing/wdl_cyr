//
//  WaybillSpecialNoHandleCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2019/1/30.
//  Copyright © 2019 yinli. All rights reserved.
//

import UIKit

class WaybillSpecialNoHandleCell: BaseCell {
    
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WaybillSpecialNoHandleCell {
    //设置cell的值
    func contentInfo(info:WayBillInfoBean?) {
        self.desiginLabel.text = ""
        //货源编号
        self.goodCodeId.text = "货源编号：" + (info?.hallId ?? "无")
        self.toAddImageForImageView(imageUrl: info?.companyLogo, imageView: self.avatorImageView)
        self.typeLabel.text = "【自营】指派任务"
        self.startLabel.text = info?.origin
        self.endLabel.text = info?.destination
        let time = Util.dateFormatter(date: (Double(info?.loadingTime ?? "0") ?? 0)/1000, formatter: "yyyy-MM-dd") + "  装货"
        
        let weight = (info?.goodsWeight ?? "") + "吨"
        self.goodsInfoLabel.text = Util.contact(strs: [time , weight], seperate: " | ")
        self.timeLabel.text = Util.contact(strs: ["成交时间:",Util.dateFormatter(date: (info?.createTime ?? 0) / 1000, formatter: "yyyy-MM-dd HH:mm:ss")])
    }
}
