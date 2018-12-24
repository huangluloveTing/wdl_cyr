 //
//  AppDelegate.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var intervalManager:ZTIntervalManager?
    private var locationManager:ZTLocationManager = ZTLocationManager.init()

    let dispose = DisposeBag()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initJPush(lanchOptions: launchOptions)
        //注册设备
        registerJPush()
        
        self.configIQKeyboard()
        self.configGAODEMap()
        self.configHUD()
        self.uploadLocationInterval()
        
        //通过这个获取registrationID 发送消息
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0{
                print("registrationID获取成功：\(String(describing: registrationID))")
            }else {
                print("registrationID获取失败：\(String(describing: registrationID))")
            }
        }
        
        decideToLogin()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.loadCarrierInfo()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
       
    }

    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
         return UIInterfaceOrientationMask.portrait
    }
    
    //MARK: - 极光
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registerToken(token: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
}

extension AppDelegate {
    
    // 获取省市区信息
    func getAreaInfo() {
        if (WDLCoreManager.shared().userInfo?.token?.count ?? 0) > 0 {
            WDLCoreManager.shared().loadAreas()
        }
    }
    
    // 获取基础信息
    static func loadNormalInfo()  {
        
    }
    
    func configIQKeyboard() {
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().toolbarDoneBarButtonItemText = "确定"
        IQKeyboardManager.shared().toolbarBarTintColor = UIColor(hex: INPUTVIEW_TINCOLOR)
        IQKeyboardManager.shared().toolbarTintColor = UIColor(hex: COLOR_BUTTON)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
    }
    
    func configGlobalNavigationBar() {
        
    }
    
    func configGAODEMap() {
        AMapServices.shared().apiKey = GAODE_MAP_KEY
        AMapServices.shared().enableHTTPS = false
    }
    
    func configHUD() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
        SVProgressHUD.setRingRadius(5)
    }
}
 
 //
 extension AppDelegate {
    
    
    func loadCarrierInfo() -> Void {
        let userInfo = WDLCoreManager.shared().userInfo
        if userInfo != nil && userInfo?.token != nil {
            WDLCoreManager.shared().loadCarrierInfo()
            WDLCoreManager.shared().loadAreas()
        }
    }
    
    //MARK: - 如果已登录，则直接进入首页
    func decideToLogin() -> Void {
        let userInfo = WDLCoreManager.shared().userInfo
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        if userInfo == nil || userInfo?.token == nil {
            let login = LoginVC()
            let naviVC = UINavigationController(rootViewController: login)
            window?.rootViewController = naviVC
        } else {
            let root = RootTabBarVC()
            window?.rootViewController = root
        }
        window?.makeKeyAndVisible()
    }
    
    // 对于app 在某个间隔时间上传地址经纬度
    func uploadLocationInterval() -> Void {
        self.intervalManager?.intervalTimeClosure = {
            return WDLCoreManager.shared().locationInterval
        }
        let userInfo = WDLCoreManager.shared().userInfo
        if userInfo != nil || userInfo?.token != nil {
            self.intervalManager = ZTIntervalManager.instance(closure: {[weak self] in
                self?.locationUser()
            })
        }
    }
    
    // 定位
    func locationUser() -> Void {
        self.locationManager.startLocation(result: { [weak self](location, error) in
            if error == nil {
                WDLCoreManager.shared().currentLocation = location
                WDLCoreManager.shared().locationInterval = 30 * 3600
                self?.uploadUserLocation(location: location!)
            } else {
                switch error! {
                case .businessError(_, let code):
                    if code == ZTLocationManager.NoLocationAuthCode {
                        // 无定位权限时
                        //TODO:
                        
                    } else {
                        self?.uploadLocationInterval()
                    }
                    WDLCoreManager.shared().locationInterval = 10 * 3600
                    break
                default:
                    WDLCoreManager.shared().locationInterval = 10 * 3600
                    self?.uploadLocationInterval()
                }
            }
        }, isContinue: false)
    }
    
    // 上传经纬度
    func uploadUserLocation(location:CLLocationCoordinate2D) -> Void {
        let info =  WDLCoreManager.shared().userInfo
        var positionVC = CarrierPositionVo()
        positionVC.latitude = Float(location.latitude)
        positionVC.longitude = Float(location.longitude)
        positionVC.carrierId = info?.id
        BaseApi.request(target: API.positionCarrier(positionVC), type: BaseResponseModel<String>.self)
            .retry(10)
            .subscribe(onNext: { (data) in
                print(data)
            })
            .disposed(by: dispose)
    }
 }

