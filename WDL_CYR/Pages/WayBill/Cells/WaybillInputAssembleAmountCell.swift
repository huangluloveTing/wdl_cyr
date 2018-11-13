//
//  WaybillInputAssembleAmountCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WaybillInputAssembleAmountCell: BaseCell {
    
    typealias WaybillInputClosure = (String)->()
    
    private let dispose = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    
    public var inputClosure:WaybillInputClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                if let closure = self?.inputClosure {
                    closure(text)
                }
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension WaybillInputAssembleAmountCell {
    
    func showInfo(num:Float? , canEdit:Bool) -> Void {
        self.textField.text = String(num ?? 0)
        self.textField.isUserInteractionEnabled = canEdit
    }
}
