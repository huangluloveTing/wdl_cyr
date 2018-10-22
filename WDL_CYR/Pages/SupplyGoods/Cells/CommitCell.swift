//
//  CommitCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/19.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommitCell: BaseCell {
    
    private let dispose = DisposeBag()
    
    typealias CommitClosure = () -> ()
    
    @IBOutlet weak var commitButton: UIButton!
    
    public var commitClosure:CommitClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commitButton.addBorder(color: nil, width: 0, radius: 4)
        self.commitButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                if let closure = self?.commitClosure {
                    closure()
                }
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
