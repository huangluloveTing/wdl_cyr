
//
//  WaybillRealTransCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2019/1/24.
//  Copyright © 2019 yinli. All rights reserved.
//

import UIKit

class WaybillRealTransCell: BaseCell {
    
    @IBOutlet weak var realLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showRealTone(tone:Float) -> Void {
        let real = tone == 0 ? "无" : Util.contact(strs: [Util.floatPoint(num: 2, floatValue: tone) , "吨"]) 
        self.realLabel.text = Util.contact(strs: ["实发吨数：" , real])
    }
    
}
