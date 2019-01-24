//
//  BaseVC+router.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/23.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

extension BaseVC {
    
   
    //跳转到应用的AppStore页页面
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id1446242710"
        let url = URL.init(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    func toRegisterVC(title:String?) { // 去注册页面
        let registerVC = RegisterVC()
        self.pushToVC(vc: registerVC , title:title)
    }
    
    func toLinkKF() { // 联系客服
        Util.toCallPhone(num: KF_PHONE_NUM)
    }
    
    func toForgetPwdVC() {
        let forgetPwdVC = ForgetPwdVC()
        self.pushToVC(vc: forgetPwdVC, title: "忘记密码")
    }
    
    // 跳转到主模块
    func toMainVC() {
        UIApplication.shared.keyWindow?.rootViewController = RootTabBarVC()
    }
    
    // 去 货物供应详情
    func toGoodsSupplyDetail() {
        let detailSupplu = GoodsSupplyDetailVC()
        self.pushToVC(vc: detailSupplu, title: "详情")
    }
    
    // 去运单详情
    func toWayBillDetail() {
        let wayBillDetail = WayBillDetailVC()
        self.pushToVC(vc: wayBillDetail, title: "运单详情")
    }
    
    // t去货源详情
    func toResouceDetail(resource:ResourceDetailUIModel) -> Void {
        let vc = ResourceDetailVC()
        vc.resource = resource
        self.pushToVC(vc: vc, title: "货源详情")
    }
    
    // 选择报价类型
    func toChooseOfferType(resource:ResourceDetailUIModel?) -> Void {
        // 去报价
        let vc = ChooseOfferTypeVC()
        vc.resource = resource
        self.pushToVC(vc: vc, title: "选择报价类型")
    }
    
    // 添加关注路线
    func toFocusLineVC() -> Void {
        let lineVC = AddLinesVC()
        self.pushToVC(vc: lineVC, title: "添加路线")
    }
    
    // 添加关注的托运人(去搜索托运人界面)
    func toResearchConsignor() -> Void {
        let consignorVC = ResearchConsignorVC()
        self.pushToVC(vc: consignorVC, title: "")
    }
    
    // 跳转到关注线路详情
    func toAttentionLineDetail(info:FollowFocusLineOrderHallResult) -> Void {
        let lineVC = PathDetailVC()
        lineVC.lineHall = info
        self.pushToVC(vc: lineVC, title: nil)
    }
    
    // 跳转到关注托运人详情
    func toAttentionConsignorDetail(consignor:FollowShipperOrderHall) -> Void {
        let consignorVC = ConsignorDetailVC()
        consignorVC.followShipper = consignor
        self.pushToVC(vc: consignorVC, title: nil)
    }
    
    //TODO: todo
    func toDelivery() {
//        let deliveryVC = DeliveryVC()
        
    }
    
    // 跳转到 评价 页面
    func toCommentVC(hallId:String) -> Void {
        let commentVC = WayBillCommentVC()
        commentVC.hallId = hallId
        self.pushToVC(vc: commentVC, title: "评价")
    }
    
    //MARK: - 进入d运单详情的相关p逻辑判断
    func transportBillDetailPage(info:WayBillInfoBean) -> Void {
        // 没有接单，不进入详情
        let detailVC = WayBillDetailVC()
        detailVC.waybillInfo = info
        detailVC.transportNo = info.transportNo ?? ""
        let status = TransportUtil.configWaybillDisplayStatus(info: info)
        switch status {
        case .unAssemble_comType_1_2_self:
            if info.driverStatus != 4 {
                detailVC.currentShowMode(mode: .unassemble_showDesignate)
                break
            }
        case .unAssemble_comType_3_toAssemble:
            detailVC.currentShowMode(mode: .unassemble_showSpecial)
            break
        case .unAssemble_comType_1_2_toAssemble:
            if info.comeType == 1 {
                detailVC.currentShowMode(mode: .unassemble_show_1_Assemble)
            }
            detailVC.currentShowMode(mode: .unassemble_show_2_Assemble)
            break
        case .unAssemble_comType_4_toDesignate:
            detailVC.currentShowMode(mode: .unassemble_showDesignate)
            break
        case .notDone_transporting :
            detailVC.currentShowMode(mode: .doing_showTransporting)
            break
        case .notDone_willTransport:
            detailVC.currentShowMode(mode: .doing_showWillTransport)
            break
        case .notDone_willSign:
            detailVC.currentShowMode(mode: .doing_showWillSign)
            break
        case .notDone_breakContractForDriver:
            print("已违约的司机 跳转 未实现")
            return
        case .notDone_breakContractForCarrier:
            detailVC.currentShowMode(mode: .doing_carrierBreak)
            break
        case .done(let mode):
            detailVC.currentShowMode(mode: .done_notCommentForCarrier)
            if mode == .noComment {
                self.toCommentVC(hallId: info.hallId ?? "")
                return
            }
        case .unAssemble_comType_1_2_noAccept:
            print("未接受不 跳转")
                return
        case .unAssemble_comType_3_noAccept:
            self.toGoodsDetail(hallId: info.hallId ?? "")
            return
        case .notDone_canEditAssemble:
            detailVC.currentShowMode(mode: .doing_canEditAssemble)
            break
        default:
            detailVC.currentShowMode(mode: .doing_showWillSign)
        }
        self.pushToVC(vc: detailVC, title: "运单详情")
    }
    
    //MARK: - 跳转到添加司机
    func toAddDriverPage() -> Void {
        let addDriver = AddDriverVC()
        
        self.pushToVC(vc: addDriver, title: "添加驾驶员")
    }
}

extension BaseVC {
    func push(vc:UIViewController , animated:Bool = true , title:String?) {
        if self.navigationController != nil {
            if let title = title {
                vc.title = title
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: animated)
        }
        else {
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    func pop(animated:Bool = true) {
        if self.navigationController != nil && (self.navigationController?.viewControllers.count)! > 1 && (self.navigationController?.viewControllers .index(of: self))! > 0 {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func toGoodsDetail(hallId:String) -> Void {
        let resouce = ResourceDetailVC()
        resouce.requestNewData = true;
        var re = ResourceDetailUIModel()
        re.id = hallId
        resouce.resource = re
        self.pushWhenPushedHiddenBottomTabbar(toVC: resouce, animation: true)
    }
}

fileprivate var key = "keyforheight"

extension BaseVC : UIViewControllerTransitioningDelegate {
    
    private var _topHeight:CGFloat {
        set {
            objc_setAssociatedObject(self, &key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as! CGFloat
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZTTransitionManager.halfTransparentTransition(duration: 0.5, topHeight: self._topHeight)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZTTransitionManager.halfDissmissTransition(duration: 0.5)
    }
    
    func smallSheetPresent(vc:UIViewController) {
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self._topHeight = IPHONE_HEIGHT*0.5
        self.present(vc, animated: true, completion: nil)
    }
    
    func bigSheetPresent(vc:UIViewController) {
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self._topHeight = IPHONE_HEIGHT*0.3
        self.present(vc, animated: true, completion: nil)
    }
}
