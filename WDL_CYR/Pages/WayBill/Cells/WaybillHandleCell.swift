//
//  WaybillHandleCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let WAYBILL_HANDLE_NAME = "WAYBILL_HANDLE_NAME"

class WaybillHandleCell: BaseCell {
    
    private let dispose = DisposeBag()

    @IBOutlet weak var handleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        handleButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.routeName(routeName: WAYBILL_HANDLE_NAME, dataInfo: nil,sender: nil)
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension WaybillHandleCell {
    func showHandleName(name:String?) -> Void {
        handleButton.setTitle(name, for: .normal)
    }
}
