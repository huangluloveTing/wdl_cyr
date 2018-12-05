//
//  WaybillNomalVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit


extension BaseVC {
    // 驾驶员选择
    func toChooseDriver(title:String? , closure:((ZbnTransportCapacity) -> ())? = nil) -> Void {
        let driverChooseVC = OfferChooseDriverVC()
        driverChooseVC.searchResultClosure = closure
        self.pushToVC(vc: driverChooseVC, title: title)
    }
    
    // 车辆选择
    func toChooseTruck(closure:((ZbnTransportCapacity) -> ())?) -> Void {
        let truckVC = OfferChooseTruckVC()
        truckVC.searchResultClosure = closure
        self.pushToVC(vc: truckVC, title: "选择车辆")
    }
    
    
    // 指派
    func toDesignate(phone:String , transportNo:String , hallId:String, closure:(() -> ())?) -> Void {
        BaseApi.request(target: API.designateWaybill(phone, transportNo , hallId), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { (data) in
                if let closure = closure {
                    closure()
                }
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    // 去配载界面
    func toAssemblePage(info:TransactionInformation? , mode:WayBillSourceTypeMode) -> Void {
        let assembleVC = WaybillAssembleVC()
        assembleVC.pageInfo = info
        assembleVC.currentDisplayMode = mode
        self.pushToVC(vc: assembleVC, title: "配载")
    }
}
