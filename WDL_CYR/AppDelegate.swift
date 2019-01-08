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
        
        //软件更新
        self.updateSoftWare()
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
    
    //MARK: - 软件更新
    //    must (integer): 是否强制更新 1=是 2=否 ,
    //softwareType (integer): 软件类型：1=托运人 2=承运人 ,
    //terminalType (integer): 终端类型：1=ios 2=Android ,
    func updateSoftWare(){
        BaseApi.request(target: API.updateSoftWare(UpdateSoftWareModel()), type: BaseResponseModel<UpdateSoftWareModel>.self)
            .subscribe(onNext: { (model) in
                let upModel = model.data
                print("更新数据：\(String(describing: upModel))")
//                if upModel?.softwareType == 2 && upModel?.terminalType == 1{

                    //判断需不需要更新(CFBundleVersion:对应配置的build 不是version: 1.1.0)
                    let infoDic: Dictionary = Bundle.main.infoDictionary ?? Dictionary()
                    let str = infoDic["CFBundleVersion"] as? String ?? ""
                    let loccationVison = Int(str) ?? 0
                    let nowVison: Int = upModel?.versionCode ?? 0

//                    if (loccationVison < nowVison) {
//                        if upModel?.must == 1{
//                            //强制更新
                            self.showCusAlert(title: "重要提示", content:upModel?.content ?? "有新版本啦，为不影响您的使用，快去appStore升级吧！" , isMust: true)
//                        }else{
//                            //自由更新
//                            self.showCusAlert(title: "重要提示", content:upModel?.content ?? "有新版本啦，快去appStore升级吧！" , isMust: false)
//                        }
//                    }

//                }
            }).disposed(by: dispose)
    }
    
    func showCusAlert(title: String, content: String, isMust: Bool)  {
        let alertVC = UIAlertController(title: title, message: content, preferredStyle: .alert)
       
    
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
           
        }
        let sureAction = UIAlertAction(title: "去升级", style: .destructive) { (_) in
            let urlString = "itms-apps://itunes.apple.com/app/id1446242710"
            let url = URL.init(string: urlString)
            UIApplication.shared.openURL(url!)
        }
        
        if isMust == true {
            //强制更新
            alertVC.addAction(sureAction)
        }else{
            //自由更新
            alertVC.addAction(cancelAction)
            alertVC.addAction(sureAction)
        }
    
        window?.rootViewController?.present(alertVC, animated: true, completion: nil)
  
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
        self.intervalManager = ZTIntervalManager.instance(closure: {[weak self] in
            if userInfo != nil || userInfo?.token != nil {
                self?.locationUser()
            }
        })
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
                        
                        let alertController = UIAlertController(title: "提示",
                                                                message: "当前无定位权限，请前往设置打开该app的定位", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                      
                        alertController.addAction(cancelAction)
                       
                        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    } else {
//                        self?.uploadLocationInterval()
                        // 定位失败，十分钟后又 定位
                        WDLCoreManager.shared().locationInterval = 10 * 3600
                    }
                    break
                default:
                    WDLCoreManager.shared().locationInterval = 10 * 3600
//                    self?.uploadLocationInterval()
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

