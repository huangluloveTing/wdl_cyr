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

let personImgs:[[UIImage]] = [[#imageLiteral(resourceName: "钱包"),#imageLiteral(resourceName: "运力"),#imageLiteral(resourceName: "认证")],[#imageLiteral(resourceName: "消息中心"), #imageLiteral(resourceName: "个人设置") , #imageLiteral(resourceName: "联系客服")]]
let personTitles:[[String]] = [["钱包","我的运力","我的认证"],["消息中心","个人设置","联系客服"]]

class PersonalVC: MainBaseVC {
    
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PersonalExcuteCell.self)") as! PersonalExcuteCell
        let img = personImgs[indexPath.section - 1][indexPath.row]
        let title = personTitles[indexPath.section - 1][indexPath.row]
        let info = PersonExcuteInfo(image: img, exTitle: title, exSubTitle: nil, showIndicator: true)
        cell.contentInfo(info: info)
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
    }
}

extension PersonalVC {
    
    // 钱包
    func toWalletVC() -> Void {
        let walletVC = WalletVC()
        self.push(vc: walletVC, title: "钱包")
    }
    
    // 我的运力
    func toTransportCapacity() -> Void {
        let tansportCapacityVC = TransportCapacityVC()
        self.push(vc: tansportCapacityVC, title: nil)
    }
    
    // 去我的认证
    func toMyAuthenVC() -> Void {
        let authenVC = MyAuthenVC()
        self.push(vc: authenVC, title: "我的认证")
    }
}
