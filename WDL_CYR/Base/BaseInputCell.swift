//
//  BaseInputCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/19.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

enum BaseInputStyle {
    case input          // 仅仅是可以输入的
    case indicatorInput // 不能输入，可以作为选择器的
    case showContent    // 仅仅用于展示内容的，可以有placeholder ，可以显示内容的
}

class BaseInputCell: BaseCell {
    
    typealias OfferInputClosure = (String) -> ()
    
    public var currentStyle:BaseInputStyle? = .input
    public var inputClosure:OfferInputClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
