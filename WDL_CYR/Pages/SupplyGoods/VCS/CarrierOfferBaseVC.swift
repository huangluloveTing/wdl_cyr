//
//  CarrierOfferBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/26.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift

class CarrierOfferBaseVC: NormalBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - net handles
extension CarrierOfferBaseVC {
    //MARK: - 报价时，获取承运人保证金、服务费等信息
    func loadCarrierInfo(hallId:String , closure:((CarrierInfoFee? , Error?)->())? ) -> Void {
       BaseApi.request(target: API.findCarrierInfoFee(hallId), type: BaseResponseModel<CarrierInfoFee>.self)
            .share(replay: 1).retry(20)
            .subscribe(onNext: { (data) in
                if let closure = closure {
                    closure(data.data , nil)
                }
                }, onError: { (error) in
                    if let closure = closure {
                        closure(nil , error)
                    }
            })
            .disposed(by: dispose)
    }
}
