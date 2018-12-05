//
//  DriverInviteFailCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class DriverInviteFailCell: BaseCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func inviteHandle(_ sender: Any) {
        self.routeName(routeName: "\(DriverInviteFailCell.self)", dataInfo: self)
    }
    
}
