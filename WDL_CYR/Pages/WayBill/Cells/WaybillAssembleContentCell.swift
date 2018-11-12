//
//  WaybillAssembleContentCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillAssembleContentCell: BaseCell {
    
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension WaybillAssembleContentCell {
    func showInfo(title:String? , content:String? , hight:Bool) -> Void {
        self.contentLabel.text = title
        self.detailLabel.text = content
        if hight == true {
            self.detailLabel.textColor = UIColor(hex: "333333")
            self.contentLabel.textColor = UIColor(hex: "333333")
        } else {
            self.detailLabel.textColor = UIColor(hex: "999999")
            self.contentLabel.textColor = UIColor(hex: "999999")
        }
    }
}
