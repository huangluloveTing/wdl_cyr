//
//  PersonalInfoHeader.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/2.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class PersonalInfoHeader: BaseCell {

    @IBOutlet weak var carrierNameLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var carrierLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PersonalInfoHeader {
    func showCarrierInfo(name:String? , auth:Bool? = false , money:Float? , logo:String?) -> Void {
        self.carrierNameLabel.text = name
//        self.authButton.isSelected = auth ?? false
        let idenStatus = auth ?? false
        if idenStatus == true {
            self.authButton.setImage(UIImage(named: "已认证"), for: .normal)
        }else{
             self.authButton.setImage(UIImage(named: "未认证"), for: .normal)
        }
        self.moneyLabel.text = Util.floatPoint(num: 2, floatValue: money ?? 0) + "元"
        Util.showImage(imageView: self.carrierLogoImageView, imageUrl: logo)
    }
}
