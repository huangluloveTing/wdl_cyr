//
//  WaybillCarrierInfoCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

/// 
class WaybillCarrierInfoCell: WaybillBaseCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var desiginNameLabel: UILabel!
    @IBOutlet weak var desiginTypeLabel: UILabel!
    @IBOutlet weak var waybillTypeDescLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var loadTimeLabel: UILabel!
    @IBOutlet weak var goodsInfoLabel: UILabel!
    @IBOutlet weak var dealTimeLabel: UILabel!
    @IBOutlet weak var truckInfoLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var waybillNoLabel: UILabel!
    
    @IBOutlet weak var twoHandleButton_1: UIButton!
    @IBOutlet weak var twoHandleButton_2: UIButton!
    @IBOutlet weak var oneHandleButton: UIButton!
    
    @IBOutlet weak var twoHandleView: UIView!
    @IBOutlet weak var oneHandleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension WaybillCarrierInfoCell {
    
    func contentInfo(info:WayBillInfoBean?, currentBtnIndex: Int) {
        if let info = info {
            //顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,(运单的分类是以下四种，判断该字段展示相应的cell)
            if currentBtnIndex == 1 {
                //1：未配载
                //info.comeType
                //4种类型判断展示 comeType: 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= 个人指派（按照rp顺序）,
                //driverStatus : Int? // (integer): 当前司机是否接受过改订单  4=接受，接受指派隐藏按钮，否则为没有进行过任何操作，显示两个按钮
                
                
            }
            else if currentBtnIndex == 2 {
                //2：未完成 依次判断 comeType 运单来源， transportStatus 运单状态 , isBreach // 是否违约 0=否,1=是 ,
                
                
            }
           
            else if currentBtnIndex == 3 {
                //3：完成 依次判断 comeType 运单来源， evaluateCode 不为空，表示承运人已经评价 ,
        
            }
            
        }
    }
}
