//
//  PaymentCommitCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let TOPAYMENT_ROUTERNAME = "TOPAYMENT_ROUTERNAME"

class PaymentCommitCell: BaseCell {
    
    private var dispose = DisposeBag()
    
    
    @IBOutlet weak var payButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        payButton.addBorder(color: nil, width: 0, radius: 4)
        payButton.rx.tap.asObservable()
            .subscribe(onNext: { () in
                
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func toCommitPay() -> Void {
        self.routeName(routeName: TOPAYMENT_ROUTERNAME, dataInfo: nil,sender: nil)
    }
}
