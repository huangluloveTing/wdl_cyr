//
//  ZTLocationManager.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/24.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class ZTLocationManager: NSObject {
    
    static public let NoLocationAuthCode = 3333 // 无定位权限，或者不能进行定位的情况下，对应的错误code
    
    typealias ZTLocationClosure = (CLLocationCoordinate2D? , CustomerError?) -> Void
    
    private var locationClosure:ZTLocationClosure?
    
    private var continueLocation:Bool? = false
    
    private var locationManager : AMapLocationManager = AMapLocationManager.init()
    
    
    public override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
    }
}

// public Method
extension ZTLocationManager {
    
    //MARK: - 是否可以使用定位功能
    static func checkLocationIsOk() -> Bool {
        let locationEnable = CLLocationManager.locationServicesEnabled()
        let status = CLLocationManager.authorizationStatus()
        if locationEnable == true && (status == .authorizedAlways || status == .authorizedWhenInUse) {
            return true;
        }
        return false;
    }
    
    /**
     * isContinue : 是否持续定位， 为 false 时 ，只定位一次，如果为 true ，
     * 会一直定位，只有通过手动关闭定位
     */
    func startLocation(result:ZTLocationClosure? , isContinue:Bool? = false) -> Void {
        self.continueLocation = isContinue
        self.locationClosure = result
        if ZTLocationManager.checkLocationIsOk() {
            self.locationManager.startUpdatingLocation()
        } else {
            if let closure = self.locationClosure {
                let customError = CustomerError.businessError("", ZTLocationManager.NoLocationAuthCode)
                closure(nil , customError)
            }
        }
    }
    
    func stopLocation() -> Void {
        self.locationManager.stopUpdatingLocation()
    }
}

extension ZTLocationManager : AMapLocationManagerDelegate {
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        if let closure = self.locationClosure {
            let customError = CustomerError.businessError(error.localizedDescription, 0)
            closure(nil , customError)
        }
        if self.continueLocation == false {
            stopLocation()
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        if let closure = self.locationClosure {
            let locationPoint = location.coordinate
            closure(locationPoint , nil)
        }
        if self.continueLocation == false {
            stopLocation()
        }
    }
    
    
}


