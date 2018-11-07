//
//  OfferSearchCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/7.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OfferSearchCell: BaseCell {
    
    typealias SearchClosure = (String) -> ()
    
    private let dispose = DisposeBag()
    
    public var searchClosure:SearchClosure?

    @IBOutlet weak var searchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                if let closure = self?.searchClosure {
                    closure(text)
                }
            })
            .disposed(by: dispose)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
