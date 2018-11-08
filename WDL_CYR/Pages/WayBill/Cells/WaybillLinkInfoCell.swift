//
//  WaybillLinkInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

///货源详情 联系人信息 cell
class WaybillLinkInfoCell: BaseCell {
    
    @IBOutlet weak var sendNameLabel: UILabel!          // 发货人
    @IBOutlet weak var loadPhoneLabel: UILabel!         // 装货电话号码
    @IBOutlet weak var loadAddressLabel: UILabel!       // 装货地址
    @IBOutlet weak var consigneeNameLabel: UILabel!     // 收货人
    @IBOutlet weak var consigneeAddressLabel: UILabel!  // 收货地址
    @IBOutlet weak var carrierNameLabel: UILabel!       // 承运人
    @IBOutlet weak var driverNameLabel: UILabel!        // 驾驶员
    @IBOutlet weak var vehicleNoLabel: UILabel!         // 车牌
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WaybillLinkInfoCell {
    
    
    func showInfo(sendName : String?,    // 发货人
                  loadPhone:String? ,   // 装货电话
                  loadAddress:String? , // 装货地址
                  consignee:String? ,   // 收货人
                  consigneeAddress:String? ,    // 收货地址
                  carrier:String? ,         // 承运人
                  driver:String? ,          // 驾驶员
                  vehicleNo:String? /*车牌*/) -> Void {
        self.sendNameLabel.text = sendName
        self.loadPhoneLabel.text = loadPhone
        self.loadAddressLabel.text = loadAddress
        self.consigneeNameLabel.text = consignee
        self.consigneeAddressLabel.text = consigneeAddress
        self.carrierNameLabel.text = carrier
        self.driverNameLabel.text = driver
        self.vehicleNoLabel.text = vehicleNo
    }
}
