//
//  TransportDriverCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransportDriverCell: BaseCell {
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var truckNoLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var idCardLabel: UILabel!
    //编辑按钮
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func toEditAction(_ sender: UIButton) {

        self.routeName(routeName: TOEDIT_TRANSPORT, dataInfo: self)
    }


    @IBAction func toDeleteAction(_ sender: UIButton) {
        self.routeName(routeName: TODELE_TRANSPORT, dataInfo: self)
    }
}

extension TransportDriverCell {
    func toShowInfo(driverName:String? ,
                    idCard:String? ,
                    phoneNum:String? ,
                    canEdit:Bool = false,
                    showEdit:Bool = false) -> Void {
        self.truckNoLabel.text = "驾驶员：".concat(one: driverName)
        self.idCardLabel.text = idCard
        self.phoneNumLabel.text = phoneNum
        self.editView.isHidden = !canEdit
        self.editButton.isHidden = !showEdit
    }
}
