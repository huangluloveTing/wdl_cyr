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
    
    @IBOutlet weak var desiginLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var desginDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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

        // Configure the view for the selected state
    }
    
}
