//
//  wdlCoreDataManager.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/7.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import HandyJSON

struct LoginInfo : HandyJSON {
    var token : String?
    var id : String?
    var carrierNo : String?
    var carrierName : String?
    var cellPhone : String?
    var idCard : String?
    var companyName : String?
    var carrierType : String?
    var vehicleAudited :String?
    var vehicleUnaudited :  String?
    var driverAudited : String?
    var driverUnaudited : String?
    var addedCount : String?
    var isAuth : Bool?
}

class WDLCoreManager: NSObject {
    
    public var regionAreas:[RegionModel]?
    
    public var userInfo: ZbnCarrierInfo?
    
    public var bondInfo: ZbnBondInfo? // 账号信息
    
    public var token:String?
    
    private static let instance = WDLCoreManager()
    private override init() {}
    
    public static func shared() -> WDLCoreManager {
        return instance
    }
}

//MARK: - 获取基本信息
extension WDLCoreManager {
    //MARK: - 获取承运人信息
    func loadCarrierInfo(closure:((ZbnCarrierInfo?) -> ())? = nil) -> Void {
        let _ = BaseApi.request(target: API.getCarrierInformation(), type: BaseResponseModel<ZbnCarrierInfo>.self)
            .retry()
            .subscribe(onNext: { (data) in
                let token = self.userInfo?.token
                var info = data.data
                if info?.token == nil {
                    info?.token = token
                }
                self.userInfo = info
                if let closure = closure {
                    closure(data.data)
                }
            })
    }
}
