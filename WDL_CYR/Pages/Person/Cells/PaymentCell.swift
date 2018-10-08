//
//  PaymentCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class PaymentCell: BaseCell {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionImageView.image = #imageLiteral(resourceName: "承运人-选中")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionImageView.isHidden = !selected
    }
    
}

extension PaymentCell {
    func showInfo(image:UIImage , title:String) -> Void {
        self.avatorImageView.image = image
        self.titleLabel.text = title
    }
}
