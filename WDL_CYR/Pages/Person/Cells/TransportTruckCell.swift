//
//  TransportTruckCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransportTruckCell: BaseCell {
    
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var truckWeightLabel: UILabel!
    @IBOutlet weak var truckLengthLabel: UILabel!
    @IBOutlet weak var truckTypeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var truckNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toEditAction(_ sender: Any) {
        self.routeName(routeName: TOEDIT_TRANSPORT, dataInfo: self)
    }
    @IBAction func toDeleteAction(_ sender: Any) {
        self.routeName(routeName: TODELE_TRANSPORT, dataInfo: self)
    }
}

extension TransportTruckCell {
    func toShowInfo(truckNo:String? ,
                    truckType:String? ,
                    truckLength:String? ,
                    truckWeight:String? ,
                    extra:String? ,
                    canEdit:Bool = false) -> Void {
        self.truckNoLabel.text = "车牌号：".concat(one: truckNo)
        self.truckTypeLabel.text = truckType
        self.truckLengthLabel.text = truckLength
        self.truckWeightLabel.text = truckWeight
        self.editView.isHidden = !canEdit
    }
}
