//
//  MoreInputCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/12.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoreInputCell: BaseCell {

    private let dispose = DisposeBag()
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    public var inputClosure:((String?)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MoreInputCell {
    func showInput(title:String?,
                   input:String?,
                   placeholder:String?,
                   inputClosure:((String?) -> ())? = nil) -> Void {
        self.nameLabel.text = title
        self.inputTextField.placeholder = placeholder
        self.inputTextField.text = input
        self.inputClosure = inputClosure
    }
}

extension MoreInputCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let closure = self.inputClosure {
            closure(textField.text)
        }
    }
}
