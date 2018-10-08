//
//  FocusLinesCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class FocusLinesCell: BaseCell {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FocusLinesCell {
    func showInfo(start:String? , end:String?) -> Void {
        self.startLabel.text = start
        self.endLabel.text = end
    }
}
