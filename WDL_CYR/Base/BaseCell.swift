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
    func rightBadgeValue(value:String? , to label:UILabel , bgColor:UIColor? = UIColor(hex: "FF5363")) {
        if Int(value ?? "") != nil {
            label.text = value
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 11)
            label.sizeToFit()
            label.backgroundColor = bgColor
            let height = label.zt_height
            label.zt_size = CGSize(width: height, height: height)
            label.addBorder(color: UIColor(hex: BADGE_VALUE_COLOR) , radius:Float(height / 2.0))
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
    func offerStatusStyle(status:Int? , to label:UILabel) -> Void {
        
    }
    
    //TODO: 报价的指派对应的展示
    func offerDesignateStyle(designate:Int? , to label:UILabel) -> Void {
        
    }
    
    //TODO: 货源详情中，货源状态
    func gsStatus(status:SourceStatus , to label:UILabel) -> Void {
        
    }
}
