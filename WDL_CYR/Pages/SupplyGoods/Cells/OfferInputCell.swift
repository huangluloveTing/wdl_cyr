//
//  OfferInputCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/19.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OfferInputCell: BaseInputCell {
    
    private let dispose = DisposeBag()

    @IBOutlet weak var indicatorView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch self.currentStyle ?? .input {
        case .input:
            self.indicatorView.isHidden = true
            self.textField.isUserInteractionEnabled = true
            break;
            
        case .indicatorInput:
            self.indicatorView.isHidden = false
            self.textField.isUserInteractionEnabled = false
            break;
            
        case .showContent:
            self.indicatorView.isHidden = true
            self.textField.isUserInteractionEnabled = false
        }

        self.textField.rx.text.orEmpty.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self](input) in
                if let closure = self?.inputClosure {
                    closure(input)
                }
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension OfferInputCell {
    
    func showInfo(title:String? , content:String? , unit:String? , placeholder:String? = "") -> Void {
        self.titleLabel.text = title
        self.textField.text = content
        self.textField.placeholder = placeholder
        self.unitLabel.text = (unit != nil) ? "("+unit!+")" : ""
    }
}
