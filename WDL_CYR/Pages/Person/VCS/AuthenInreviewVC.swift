//
//  AuthenInreviewVC.swift
//  WDL_CYR
//
//  Created by yaya on 2018/11/5.
//  Copyright © 2018 yinli. All rights reserved.


import UIKit
import RxSwift
import RxCocoa
class AuthenInreviewVC: NormalBaseVC {

    let disposeBag = DisposeBag()
    //打电话
    @IBOutlet weak var callButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //打电话

        self.callButton.rx.tap
            .subscribe(onNext: {
                Util.toCallPhone(num: "0310 6591999")
            }).disposed(by: disposeBag)
        
    }
    

    

}
