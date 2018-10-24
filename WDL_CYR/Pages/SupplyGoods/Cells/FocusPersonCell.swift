//
//  FocusPersonCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class FocusPersonCell: BaseCell {
    
    @IBOutlet weak var focusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FocusPersonCell {
    
    func focusPersonInfo(image url:String? , title:String? , badge:Int) -> Void {
        self.toAddImageForImageView(imageUrl: url, imageView: self.focusImageView)
        self.titleLabel.text = title
        self.rightBadgeValue(value: String(badge), to: self.numberLabel, radius: 10)
    }
}
