//
//  wdlCoreDataManager.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/7.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

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
    
    public var locationInterval:TimeInterval = 30 * 3600 // 30秒定位一次
    private var _regions:[RegionModel]?
    private var _userInfo:ZbnCarrierInfo?
    public var currentLocation:CLLocationCoordinate2D? // 当前定位
    
    public var regionAreas:[RegionModel]? {
        set {
            _regions = newValue
            UserStore.storeRegionsInfo(regions: newValue)
        }
        get {
            if _regions == nil {
                _regions = UserStore.loadRegisonInfo()
            }
            return _regions
        }
    }
    
    public var userInfo: ZbnCarrierInfo? {
        set {
            _userInfo = newValue
            UserStore.storeUserInfo(info: newValue)
        }
        get {
            guard let value = _userInfo else {
                _userInfo = UserStore.loadUserInfo()
                return _userInfo
            }
            return value
        }
    }
    
    public var bondInfo: ZbnBondInfo? // 账户信息
    
    public var token:String?
    //未读条数
    public var unreadMessageCount:Int = 0
    
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
            .throttle(2, scheduler: MainScheduler.instance)
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
    
    
    
    public func loadUnReadMessage(closure:((Int)->())?) {
        let _ = BaseApi.request(target: API.getMessageNum(), type: BaseResponseModel<Int>.self)
            .retry()
            .subscribe(onNext: { (data) in
                self.unreadMessageCount = data.data ?? 0
                if let closure = closure {
                    closure(data.data ?? 0)
                }
            })
    }
    
    public func loadAreas(closure:(([RegionModel])->())? = nil) {
       let _ = BaseApi.request(target: API.loadTaskInfo(), type: BaseResponseModel<[RegionModel]>.self)
            .retry()
            .subscribe(onNext: { [weak self](data) in
                self?.regionAreas = data.data ?? []
                if let closure = closure {
                    closure(data.data ?? [])
                }
            })
    }
    
}
