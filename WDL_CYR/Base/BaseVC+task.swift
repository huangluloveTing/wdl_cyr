//
//  BaseVC+task.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/1.
//  Copyright © 2018 yinli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension BaseVC {
    // 获取承运人保证金数据
    func loadCarrierBoundTask() -> Observable<BaseResponseModel<ZbnBondInfo>> {
        let task = BaseApi.request(target: API.zbnBondInformation(), type: BaseResponseModel<ZbnBondInfo>.self)
            .throttle(1, scheduler: MainScheduler.instance)
        return task
    }
}
