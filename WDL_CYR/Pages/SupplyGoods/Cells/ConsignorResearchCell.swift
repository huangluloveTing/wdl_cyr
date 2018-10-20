//
//  ConsignorResearchCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ConsignorResearchCell: BaseCell {
    
    typealias ConsignorTapAttentionClosure = () -> ()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var attentionedView: UIView!
    
    public var tapAttentionClosure:ConsignorTapAttentionClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configSubViews() {
        self.attentionButton.addBorder(color: nil, width: 0, radius: 14)
        self.attentionedView.addBorder(color: UIColor(hex: "DDDDDD"), width: 0.5, radius: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func atttentionHandle(_ sender: Any) {
        if let closure = self.tapAttentionClosure {
            closure()
        }
    }
}

extension ConsignorResearchCell {
    func showInfo(logoImage:String? , companyName:String? , focused:Bool? = false) -> Void {
        self.toAddImageForImageView(imageUrl: logoImage, imageView: self.logoImageView)
        self.companyNameLabel.text = companyName
        self.attentionedView.isHidden = !(focused ?? false)
    }
}
