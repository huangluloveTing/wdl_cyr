//
//  InviteDriverCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class InviteDriverCell: BaseCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var idCardNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension InviteDriverCell {
    func showInfo(name:String , phone:String , idCard:String) -> Void {
        self.nameLabel.text = Util.contact(strs: ["驾驶员:" , name])
        self.phoneLabel.text = phone
        self.idCardNoLabel.text = idCard
    }
}
