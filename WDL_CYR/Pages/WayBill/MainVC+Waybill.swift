//
//  WaybillNomalVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/9.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit


extension MainBaseVC {
    // 驾驶员选择
    func toChooseDriver(title:String? , closure:((ZbnTransportCapacity) -> ())? = nil) -> Void {
        let driverChooseVC = OfferChooseDriverVC()
        driverChooseVC.searchResultClosure = closure
        self.push(vc: driverChooseVC, title: title)
    }
    
    // 车辆选择
    func toChooseTruck(closure:((ZbnTransportCapacity) -> ())?) -> Void {
        let truckVC = OfferChooseTruckVC()
        truckVC.searchResultClosure = closure
        self.push(vc: truckVC, title: "选择车辆")
    }
    
    
    // 指派
    func toDesignate(phone:String , transportNo:String , closure:(() -> ())?) -> Void {
        BaseApi.request(target: API.designateWaybill(phone, transportNo), type: BaseResponseModel<String>.self)
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
    func toAssemblePage(info:TransactionInformation) -> Void {
        let assembleVC = WaybillAssembleVC()
        assembleVC.pageInfo = info
        if info.sourceType == 1 {
            assembleVC.currentDisplayMode = .driverAssemble
        }
        if info.sourceType == 2 {
            assembleVC.currentDisplayMode = .carrierAssemble
        }
        
        if info.sourceType == 3 {
            assembleVC.currentDisplayMode = .planAssemble
        }
        
        self.push(vc: assembleVC, title: "配载")
    }
}
