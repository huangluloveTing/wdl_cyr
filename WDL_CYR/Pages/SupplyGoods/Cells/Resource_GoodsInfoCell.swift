//
//  Resource_GoodsInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class Resource_GoodsInfoCell: BaseCell {
    
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var goodsSumLabel: UILabel!
    @IBOutlet weak var goodsTypeLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension Resource_GoodsInfoCell {
    func showInfo(start:String ,
                  end:String ,
                  loadTime:TimeInterval ,
                  goodsName:String ,
                  goodsType:String ,
                  goodsSumm:String ,
                  remark:String) -> Void {
        self.startLabel.text = start
        self.endLabel.text = end
        self.loadTimeLabel.text = Util.dateFormatter(date: loadTime, formatter: "yyyy-MM-dd")
        self.goodsNameLabel.text = goodsName
        self.goodsSumLabel.text = goodsSumm
        self.goodsTypeLabel.text = goodsType
        self.remarkLabel.text = remark
    }
}
