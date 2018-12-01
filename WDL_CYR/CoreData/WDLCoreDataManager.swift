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
    
    public var userInfo: LoginInfo?
    
    public var zbnCarrierInfo:ZbnCarrierInfo? 
    
    public var token:String?
    
    private static let instance = WDLCoreManager()
    private override init() {}
    
    public static func shared() -> WDLCoreManager {
        return instance
    }
    
    
}
