//
//  InviteDriverCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class InviteDriverCell: BaseCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var idCardNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.addBorder(color: nil, width: 0, radius: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addHandle(_ sender: Any) {
        self.routeName(routeName: "\(InviteDriverCell.self)", dataInfo: self,sender: sender)
    }
}

extension InviteDriverCell {
    func showInfo(name:String? , phone:String? , idCard:String?) -> Void {
        self.driverNameLabel.text = Util.concatSeperateStr(seperete:"", strs:  "驾驶员: " , name)
        self.phoneLabel.text = phone
        self.idCardNoLabel.text = idCard
    }
}
