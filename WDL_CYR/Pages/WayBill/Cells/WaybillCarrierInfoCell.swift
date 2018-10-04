//
//  WaybillCarrierInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

/// 
class WaybillCarrierInfoCell: WaybillBaseCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var desiginNameLabel: UILabel!
    @IBOutlet weak var desiginTypeLabel: UILabel!
    @IBOutlet weak var waybillTypeDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var dealTimeLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var waybillNoLabel: UILabel!
    
    @IBOutlet weak var twoHandleButton_1: UIButton!
    @IBOutlet weak var twoHandleButton_2: UIButton!
    @IBOutlet weak var oneHandleButton: UIButton!
    
    @IBOutlet weak var twoHandleView: UIView!
    @IBOutlet weak var oneHandleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
