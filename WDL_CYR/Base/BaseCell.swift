//
//  BaseCell.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/25.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import Kingfisher


class BaseCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configSubViews()
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 待重写的方法，配置子视图
    func configSubViews() -> Void {
        
    }
}


// 右边的 气泡数量 / 副标题 / 主标题
extension BaseCell {
    
    // cell上 气泡的设置
    func rightBadgeValue(value:String? , to label:UILabel , bgColor:UIColor? = UIColor(hex: "FF5363") , radius:Float) {
        if Int(value ?? "") != nil {
            label.text = value
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 11)
            label.backgroundColor = bgColor
            label.textAlignment = .center
            label.addBorder(color: UIColor(hex: BADGE_VALUE_COLOR) , radius:radius)
        }
    }
    
    // cell 上 副标题
    func subTitle(title:String? , to label:UILabel) {
        label.text = title
        label.textColor = UIColor(hex: SUB_TITLE_VALUE_COLOR)
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
    // cell 上 主标题
    func mainTitle(title:String? , to label:UILabel) {
        label.text = title
        label.textColor = UIColor(hex: TITLE_VALUE_COLOR)
        label.font = UIFont.systemFont(ofSize: 15)
    }
}

// 处理ZTTagView 
extension BaseCell {
    
}

// 添加图片
extension BaseCell {
    func toAddImageForImageView(imageUrl:String? , imageView:UIImageView) -> Void {
        let resource = URL(string: imageUrl ?? "")
        imageView.kf.setImage(with: (resource))
    }
}

// 报价状态显示样式
extension BaseCell {
    
    //TODO: 需要完善对应的报价 时的状态情况
    func offerStatusStyle(status:WDLOfferDealStatus? , to label:UILabel) -> Void {
        switch status ?? .reject {
        case .reject:
            label.text = "已驳回"
            break
        case .inbinding:
            label.text = "竞价中"
            break
        case .deal:
            label.text = "已成交"
            break
        case .done:
            label.text = "已完成"
            break
        case .willDesignate:
            label.text = "待指派"
            break
        case .canceled:
            label.text = "已取消"
            break
        case .notDone:
            label.text = "未完成"
            break
        }
    }
    
    //TODO: 报价的指派对应的展示
    func offerDesignateStyle(designate:Int? , to label:UILabel) -> Void {
        if designate == 4 {
            label.textColor = UIColor(hex: "06C06F")
            label.text = "待指派"
        }
        else if designate == 0 {
            label.textColor = UIColor(hex: "06C06F")
            label.text = "已驳回"
        }
        else if designate == 5 {
            label.textColor = UIColor(hex: "06C06F")
            label.text = "已取消"
        }
        else if designate == 3 {
            label.textColor = UIColor(hex: "06C06F")
            label.text = "已完成"
        }
        else {
            label.textColor = UIColor.blue
            label.text = "查看运单"
        }
    }
    
    //TODO: 货源详情中，货源状态
    func gsStatus(status:SourceStatus , to label:UILabel) -> Void {
        
    }
}
