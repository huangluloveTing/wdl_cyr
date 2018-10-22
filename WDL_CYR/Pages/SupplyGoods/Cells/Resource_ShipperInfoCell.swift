//
//  Resource_ShipperInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class Resource_ShipperInfoCell: BaseCell {
    
    
    @IBOutlet weak var focusShipperButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dealTotalLabel: UILabel!
    @IBOutlet weak var shipperNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.focusShipperButton.addBorder(color: nil, width: 0, radius: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func focusShipperHandle(_ sender: Any) {
        self.routeName(routeName: "\(Resource_ShipperInfoCell.self)", dataInfo: nil)
    }
}

extension Resource_ShipperInfoCell {
    func showInfo(name:String? , dealNum:Int , rate:Float) -> Void {
        self.shipperNameLabel.text = name
        self.dealTotalLabel?.text = String(dealNum) + "笔"
        self.rateLabel.text = Util.floatPoint(num: 0, floatValue: rate) + "分"
    }
}
