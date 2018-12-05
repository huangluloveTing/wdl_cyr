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

    let dispose = DisposeBag()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initJPush(lanchOptions: launchOptions)
        //注册设备
        registerJPush()
        let login = LoginVC()
        let naviVC = UINavigationController(rootViewController: login)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = naviVC
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        self.configIQKeyboard()
        self.configGAODEMap()
        self.configHUD()
        
        //通过这个获取registrationID 发送消息
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0{
                print("registrationID获取成功：\(String(describing: registrationID))")
            }else {
                print("registrationID获取失败：\(String(describing: registrationID))")
            }
        }
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
            BaseApi.request(target: API.loadTaskInfo(), type: BaseResponseModel<[RegionModel]>.self)
                .throttle(2, scheduler: MainScheduler.instance)
                .retry()
                .subscribe(onNext: {(regions) in
                    WDLCoreManager.shared().regionAreas = regions.data
                }, onError: { (error) in
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5, execute: {[weak self] in
                        self?.getAreaInfo()
                    })
                })
                .disposed(by: dispose)
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
 
 // 联系 反射
 extension AppDelegate {
    
    func mirro() {
        
    }
    
    func loadCarrierInfo() -> Void {
        WDLCoreManager.shared().loadCarrierInfo()
    }
 }

