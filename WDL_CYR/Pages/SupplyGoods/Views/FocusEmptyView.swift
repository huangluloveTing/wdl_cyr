//
//  FocusEmptyView.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class FocusEmptyView: UIView {
    
    typealias FocusEmptyViewTapButtonClosure = () -> ()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    public var tapClosure:FocusEmptyViewTapButtonClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.addBorder(color: nil, width: 0, radius: 2)
    }
    
    func empty(title:String? , desc:String? , buttonTitle:String?) -> Void {
        self.titleLabel.text = title
        self.descriptionLabel.text = desc
        self.button.setTitle(buttonTitle, for: .normal)
    }
    @IBAction func tapButtonAction(_ sender: Any) {
        if let closure = self.tapClosure {
            closure()
        }
    }
}
