//
//  Resource_GoodsInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class Resource_GoodsInfoCell: BaseCell {
    //货源编号：id
    @IBOutlet weak var goodCodeId: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var goodsSumLabel: UILabel!
    @IBOutlet weak var goodsTypeLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var focusLineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.focusLineButton.addBorder(color: nil, width: 0, radius: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func focusLineHandle(_ sender: Any) {
        self.routeName(routeName: "\(Resource_GoodsInfoCell.self)", dataInfo: nil,sender: sender)
    }
}
//货源详情- 货源信息
extension Resource_GoodsInfoCell {
    func showInfo(start:String ,
                  end:String ,
                  loadTime:TimeInterval ,
                  goodsName:String? ,
                  goodsType:String? ,
                  goodsSumm:String? ,
                  remark:String?,
                  goodCode:String?,
                  foucs:Bool) -> Void {
        self.startLabel.text = start
        self.endLabel.text = end
        self.loadTimeLabel.text = Util.dateFormatter(date: loadTime / 1000, formatter: "yyyy-MM-dd")
        self.goodsNameLabel.text = goodsName
        self.goodsSumLabel.text = goodsSumm
        self.goodsTypeLabel.text = goodsType
        self.remarkLabel.text = remark
        //货源编号
        self.goodCodeId.text = "货源编号：" + (goodCode ?? "")
        self.focusLineButton.isHidden = foucs;
    }
}
