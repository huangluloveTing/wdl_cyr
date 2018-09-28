//
//  GSDetail_notDealCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetail_notDealCell: BaseCell {

    @IBOutlet weak var reasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension GSDetail_notDealCell {
    
    func showNotReason(reson:String) -> Void {
        self.reasonLabel.text = "未成交原因：" + reson
    }
}
