//
//  WaybillGoodsInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillGoodsInfoCell: BaseCell {
    //货源编号
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var dealTimeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsTypeLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var goodsWeightLabel: UILabel!
    @IBOutlet weak var packageTypeLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension WaybillGoodsInfoCell {
    func showGoodsInfo(dealTime:TimeInterval? ,
                       start:String? ,
                       end:String? ,
                       goodsType:String? ,
                       loadTime:TimeInterval? ,
                       weight:Float? ,
                       pacakge:String? ,
                       length:String? ,
                       vehicleType:String?,
                       goodId:String?) -> Void {
        self.dealTimeLabel.text = Util.dateFormatter(date: dealTime ?? 0, formatter: "yyyy-MM-dd HH:mm:ss")
        self.startLabel.text = start
        self.endLabel.text = end
        self.goodsTypeLabel.text = goodsType
        self.loadTimeLabel.text = Util.dateFormatter(date: loadTime ?? 0, formatter: "yyyy-MM-dd")
        self.goodsWeightLabel.text = Util.floatPoint(num: 2, floatValue: weight ?? 0) + "吨"
        self.packageTypeLabel.text = pacakge
        self.lengthLabel.text = length
        self.vehicleTypeLabel.text = vehicleType
        self.codeLabel.text = "货源编号：" + (goodId ?? "")
    }
}
