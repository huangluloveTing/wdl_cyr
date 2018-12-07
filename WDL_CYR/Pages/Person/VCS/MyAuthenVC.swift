//
//  MyAuthenVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

enum MyAuthenStatus {
    case individual
    case enterprise
}

/// 我的认证
class MyAuthenVC: NormalBaseVC {
    
    @IBOutlet weak var individualView: UIView!
    @IBOutlet weak var enterpriseView: UIView!
    @IBOutlet weak var enterpriseSelectionView: UIImageView!
    @IBOutlet weak var individualSelectionView: UIImageView!
    
    
    private var currentStatus:MyAuthenStatus = .individual
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailUI()
    }
    
    override func bindViewModel() {
        self.individualView.singleTap { [weak self](_) in
            self?.currentStatus = .individual
            self?.currentShowUI()
        }
        self.enterpriseView.singleTap { [weak self](_) in
            self?.currentStatus = .enterprise
            self?.currentShowUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextProgressAction(_ sender: Any) {
        self.tapNext()
    }
}

extension MyAuthenVC {
    
    func initailUI() -> Void {
        self.currentShowUI()
        self.view.backgroundColor = UIColor.white
    }
    
    func currentShowUI() -> Void {
        switch self.currentStatus {
        case .individual:
            self.individualSelectionView.isHidden = false
            self.enterpriseSelectionView.isHidden = true
            break
        default:
            self.individualSelectionView.isHidden = true
            self.enterpriseSelectionView.isHidden = false
        }
    }
    
    func tapNext() -> Void {
        switch self.currentStatus {
        case .individual:
            self.toIndividual()
            break
        default:
            self.toEnterprise()
        }
    }
    
    // 点击个人(carrierType = 1)
    func toIndividual() -> Void {
        
        let individualAuthenVC = AuthenIndividualInfoVC()
        self.push(vc: individualAuthenVC, title: "我的认证")
    
    }
    
    // 点击企业(carrierType = 2)
    func toEnterprise() -> Void {
        let enterpriseAuthenVC = AuthenEnterpriseVC()
        self.pushToVC(vc: enterpriseAuthenVC, title: "我的认证")
    }
}
