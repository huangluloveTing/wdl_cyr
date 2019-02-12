//
//  WaybillSepecialInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WaybillSepecialInfoCell: WaybillBaseCell {
    
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatorImageView: UIImageView!
    //货源编号：id
    @IBOutlet weak var goodCodeId: UILabel!
    @IBOutlet weak var desiginLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var desginDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var twoHandleButton_2: UIButton!
    @IBOutlet weak var twoHandleButton_1: UIButton!
    @IBOutlet weak var oneHandleButton: UIButton!
    @IBOutlet weak var oneHandleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func assembleAction(_ sender: Any) {
        self.toAssembleWaybill(param: self)
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        self.routeName(routeName: EVENT_NAME_REJECTPLAN, dataInfo: self)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.routeName(routeName: EVENT_NAME_ACCEPTPLAN, dataInfo: self)
    }
}

extension WaybillSepecialInfoCell {
    //设置cell的值
    func contentInfo(info:WayBillInfoBean?) {
        let status = TransportUtil.configWaybillDisplayStatus(info: info!)
        self.desiginLabel.text = ""
        //货源编号
        self.goodCodeId.text = "货源编号：" + (info?.hallId ?? "无")
        self.toAddImageForImageView(imageUrl: info?.companyLogo, imageView: self.avatorImageView)
        self.typeLabel.text = "【自营】指派任务"
        self.startLabel.text = info?.origin
        self.endLabel.text = info?.destination
        let time = Util.dateFormatter(date: (Double(info?.loadingTime ?? "0") ?? 0)/1000, formatter: "yyyy-MM-dd") + "  装货"
        
        let weight = (info?.goodsWeight ?? "") + "吨"
        self.goodsInfoLabel.text = Util.contact(strs: [time , weight], seperate: " | ")
        self.timeLabel.text = Util.contact(strs: ["成交时间:",Util.dateFormatter(date: (info?.createTime ?? 0) / 1000, formatter: "yyyy-MM-dd HH:mm:ss")])
        switch status {
        case .unAssemble_comType_3_noAccept:
            acceptAndRejectInfoView(info: info)
            break
        default:
            assembleInfoView(info: info)
        }
    }
    
    // 可以配载的情况
    func assembleInfoView(info:WayBillInfoBean?) -> Void {
        self.oneHandleView.isHidden = false
    }
    // 可以接受拒绝的情况
    func acceptAndRejectInfoView(info:WayBillInfoBean?) -> Void {
        self.oneHandleView.isHidden = true
    }
    // 其他情况不显示
}
