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
        
        let login = LoginVC()
        let naviVC = UINavigationController(rootViewController: login)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = naviVC
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        self.configIQKeyboard()
        self.configGAODEMap()
        self.configHUD()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.loadCarrierInfo()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
         return UIInterfaceOrientationMask.portrait
    }
    
}

extension AppDelegate {
    
    // 获取省市区信息
    func getAreaInfo() {
        if (WDLCoreManager.shared().userInfo?.token?.count ?? 0) > 0 {
            BaseApi.request(target: API.loadTaskInfo(), type: BaseResponseModel<[RegionModel]>.self)
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

