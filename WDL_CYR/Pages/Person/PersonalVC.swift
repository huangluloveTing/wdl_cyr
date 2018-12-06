//
//  PersonalVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/24.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


let personImgs:[[UIImage]] = [[#imageLiteral(resourceName: "钱包"),#imageLiteral(resourceName: "运力"),#imageLiteral(resourceName: "认证")],[#imageLiteral(resourceName: "消息中心"), #imageLiteral(resourceName: "个人设置")]]
let personTitles:[[String]] = [["钱包","我的运力","我的认证"],["消息中心","个人设置"]]
class PersonalVC: MainBaseVC {
    
    private var carrierInfo = WDLCoreManager.shared().userInfo
    private var carrierBondInfo = WDLCoreManager.shared().bondInfo
    private var currentMessageNum: String = ""//当前信息个数
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dropHintView: DropHintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.fd_prefersNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadCarrierInfo()
        self.loadCarrierBoundMoney()
        //获取消息个数
        self.getMessageNum()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func currentConfig() {
        self.configTableView()
        self.registerCell(nibName: "\(PersonalInfoHeader.self)", for: self.tableView)
        self.registerCell(nibName: "\(PersonalExcuteCell.self)", for: self.tableView)
    }
    
    override func bindViewModel() {
        self.tableView.rx.itemSelected.asObservable()
            .subscribe(onNext: { (indexPath) in
                
            })
            .disposed(by: dispose)
    }
}

// datasource
extension PersonalVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension PersonalVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return personTitles[section - 1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(PersonalInfoHeader.self)") as! PersonalInfoHeader
            cell.showCarrierInfo(name: self.carrierInfo?.carrierName ,
                                 auth: self.carrierInfo?.isAuth == .authed ,
                                 money: self.carrierBondInfo?.useableMoney,
                                 logo: self.carrierInfo?.headPortrait)
            return cell
        }
        var showIndicator = true
        var subTitle = ""
        var badge:Int? = nil
        // 认证i信息
        if indexPath.section == 1 && indexPath.row == 2 {
            if self.carrierInfo?.isAuth == .authed {
                subTitle = "认证"
            } else {
                subTitle = "未认证"
            }
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            badge = self.unReadMessageCount()
        }
        if indexPath.section == 2 && indexPath.row == 2 {
            showIndicator = false
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PersonalExcuteCell.self)") as! PersonalExcuteCell
        let img = personImgs[indexPath.section - 1][indexPath.row]
        let title = personTitles[indexPath.section - 1][indexPath.row]
        let info = PersonExcuteInfo(image: img, exTitle: title, exSubTitle: subTitle, showIndicator: showIndicator)
        cell.contentInfo(info: info , badgeValue: badge)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0  {
                self.toWalletVC()
            }
            if indexPath.row == 1 {
                self.toTransportCapacity()
            }
            if indexPath.row == 2 {
                self.toMyAuthenVC()
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                //消息中心
                self.toMessageCenter()
            }
            if indexPath.row == 1 {
                //个人设置
                self.toPersonSetting()
            }

        }
        
        
        
    }
}

//MARK: - 页面数据
extension PersonalVC {
    //是否认证
    func isAuthed() -> Bool {
        return false
    }
    
    //消息个数
    func unReadMessageCount() -> Int {
        return Int(self.currentMessageNum) ?? 0
    }
}

extension PersonalVC {
    
    // t去个人设置
    func toPersonSetting() -> Void {
        let settingVC = PersonSettingVC()
        self.push(vc: settingVC, title: "个人设置")
    }
    
    //MARK: - 去消息中心
    func toMessageCenter() -> Void {
        let messageCenter = MessageCenterVC()
        self.push(vc: messageCenter, title: "消息中心")
    }
    // 钱包
    func toWalletVC() -> Void {
        let walletVC = WalletVC()
        self.pushToVC(vc: walletVC, title: "钱包")
    }
    
    // 我的运力
    func toTransportCapacity() -> Void {
        let tansportCapacityVC = TransportCapacityVC()
        self.pushToVC(vc: tansportCapacityVC, title: nil)
    }
    
    // 去我的认证
    func toMyAuthenVC() -> Void {
        let authenVC = MyAuthenVC()
        self.pushToVC(vc: authenVC, title: "我的认证")
    }
    
    //获取消息个数
    func getMessageNum() -> Void {
        WDLCoreManager.shared().loadUnReadMessage { [weak self](count) in
            self?.currentMessageNum = String(format: "%ld", count)
            self?.tableView.reloadData()
      
        }
    }
    
    // 获取承运人信息
    func loadCarrierInfo() -> Void {
        WDLCoreManager.shared().loadCarrierInfo { (info) in
            self.carrierInfo = info
            self.tableView.reloadData()
        }
    }
    
    // 获取承运人保证金数据
    func loadCarrierBoundMoney() -> Void {
        self.loadCarrierBoundTask().asObservable()
            .retry()
            .subscribe(onNext: { (data) in
                WDLCoreManager.shared().bondInfo = data.data
                self.carrierBondInfo = data.data
                self.tableView.reloadData()
            })
            .disposed(by: dispose)
    }
    
    // 根据当前的认证状态，跳转到对应的页面
    func authStatusToPage() -> Void {
//        let status = carrierInfo?.isAuth
        
    }
    
    //MAR: - 去企业认证成功的页面
    func toEnterpriseAuthedPage() -> Void {
        let enterpriseVC = EnterpriseAuthedPage()
        self.pushToVC(vc: enterpriseVC, title: "认证")
    }
    
    //MARK: - 去个人认证成功的页面
    func toIndividualAuthedPage() -> Void {
        let enterpriseVC = IndividualAuthedVC()
        self.pushToVC(vc: enterpriseVC, title: "认证")
    }
    
    //MARK: - 去认证失败的页面
    func toAuthFailPage() -> Void{
        let failPage = AuthenFailVC()
        self.pushToVC(vc: failPage, title: "我的认证")
    }
    
    //MARK: - 去认证中的页面
    func toAuthingPage() -> Void {
        let page = AuthenInreviewVC()
        self.pushToVC(vc: page, title: "我的认证")
    }
    
}
