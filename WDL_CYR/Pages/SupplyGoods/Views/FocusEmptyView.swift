//
//  FocusEmptyView.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FocusEmptyView: UIView {
    
    let dispose = DisposeBag()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    @IBAction func tapButtonAction(_ sender: Any) {
        if let closure = self.tapClosure {
            closure()
        }
    }
}
