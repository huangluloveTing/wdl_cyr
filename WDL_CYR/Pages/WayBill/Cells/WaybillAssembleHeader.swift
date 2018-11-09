//
//  WaybillAssembleHeader.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WaybillAssembleHeader: UIView {
    
    typealias WaybillAssembleDeleteClosure = ()->()

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var deleteClosure:WaybillAssembleDeleteClosure?
   
    private let dispose = DisposeBag()
    
    static func instance(title:String? , showDelete:Bool) -> WaybillAssembleHeader? {
        let view = loadBindView(viewName: WaybillAssembleHeader.self)
        view?.deleteButton.isHidden = !showDelete
        view?.titleLabel.text = title
        view?.configViews()
        return view
    }

    
    func configViews() -> Void {
        self.deleteButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                if let clsoure = self?.deleteClosure {
                    clsoure()
                }
            })
            .disposed(by: dispose)
    }
}
