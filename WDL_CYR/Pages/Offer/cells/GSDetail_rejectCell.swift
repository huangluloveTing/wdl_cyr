//
//  GSDetail_rejectCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetail_rejectCell: BaseCell {

    @IBOutlet weak var rejectReasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension GSDetail_rejectCell {
    func showRejectReason(reject:String) -> Void {
        self.rejectReasonLabel.text = "驳回原因："+reject
    }
}
