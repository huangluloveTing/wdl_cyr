//
//  WaybillNoHandleCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/7.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class WaybillNoHandleCell: WaybillBaseCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tyNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var dealTimeLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var transportNoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension WaybillNoHandleCell {
    //设置cell的值
    func contentInfo(info:WayBillInfoBean?, currentBtnIndex: Int) {
        self.showInfo(info: info)
    }
    
    
    // 通用的信息展示
    func showInfo(info:WayBillInfoBean?) {
        self.configStatus(status: (info?.transportStatus)!, statusLabel: self.statusLabel , comment: info?.evaluateCode)
        self.toAddImageForImageView(imageUrl: info?.companyLogo, imageView: self.logoImageView)
        self.showFirstLineInfo(info: info, tyLabel: tyNameLabel, middleLabel: typeLabel, lastLabel: typeDescLabel)
        self.startLabel.text = info?.origin
        self.endLabel.text = info?.destination
        self.goodsInfoLabel.text = Util.contact(strs: [Util.dateFormatter(date: (Double(info?.loadingTime ?? "0") ?? 0) / 1000, formatter: "yyyy-MM-dd") , "装货" , info?.goodsName ?? ""], seperate: "    ")
        let weight = (info?.goodsWeight ?? "") + "吨"
        self.truckInfoLabel.text = Util.contact(strs: [weight , info?.vehicleLength ?? "" , info?.vehicleWidth ?? "" , info?.goodsType ?? ""], seperate: " | ")
        self.unitLabel.text = String(info?.refercneceUnitPrice ?? 0) + "元"
        self.totalLabel.text = String(info?.refercneceTotalPrice ?? 0) + "元"
        self.transportNoLabel.text = info?.transportNo
        self.dealTimeLabel.text = Util.dateFormatter(date: (info?.createTime ?? 0)/1000 , formatter: "yyyy-MM-dd HH:mm:ss")
       
    }
}
