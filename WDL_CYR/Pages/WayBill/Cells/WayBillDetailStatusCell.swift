//
//  WayBillDetailStatusCell.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/1.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillDetailStatusCell: BaseCell {
    
    private var wayBillStatusView:WayBillStatusView?
    //运单号
    @IBOutlet weak var wayBillNoLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wayBillStatusView = WayBillStatusView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH - 80, height: 64))
        self.wayBillStatusView?.status = WayBillStatus.ToReceive
        self.statusView.addSubview(self.wayBillStatusView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showInfo(status:WayBillTransportStatus, transpoNo:String) -> Void {
        //设置运单号
        self.wayBillNoLabel.text = "运单号：" + transpoNo
        //运单状态
        switch status {
        case .willStart:
            self.wayBillStatusView?.status = WayBillStatus.willToDo
            break
        case .noStart:
            self.wayBillStatusView?.status = WayBillStatus.NOT_Start
            break
        case .willToTransport:
            self.wayBillStatusView?.status = WayBillStatus.Start
            break
        case .transporting:
            self.wayBillStatusView?.status = WayBillStatus.Transporting
            break
        case .willToPickup:
            self.wayBillStatusView?.status = WayBillStatus.ToReceive
            break
        case .done:
            self.wayBillStatusView?.status = WayBillStatus.Done
            break
        }
    }
    
}


