//
//  EnterpriseAuthedPage.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/6.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class EnterpriseAuthedPage: NormalBaseVC {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var idCardLabel: UILabel!
    @IBOutlet weak var legeNameLabel: UILabel!
    @IBOutlet weak var enterpriseSumLabel: UILabel!
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var oppositeImageView: UIImageView!
    @IBOutlet weak var handleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarbuttonItem(withTitle: "申请变更")
    }

    override func currentConfig() {
        let info = WDLCoreManager.shared().userInfo
        Util.showImage(imageView: self.handleImageView, imageUrl: info?.idCardHandheld, placeholder: self.handleImageView.image!)
        Util.showImage(imageView: self.frontImageView, imageUrl: info?.idCardFrontage, placeholder: self.frontImageView.image!)
        Util.showImage(imageView: self.oppositeImageView, imageUrl: info?.idCardOpposite, placeholder: self.oppositeImageView.image!)
        self.enterpriseNameLabel.text = info?.companyName ?? " "
        self.enterpriseSumLabel.text = info?.companyAbbreviation ?? " "
        self.legeNameLabel.text = info?.legalPerson ?? " "
        self.idCardLabel.text = info?.idCard ?? " "
        self.licenseLabel.text = info?.businessLicenseNo ?? " "
        self.addressLabel.text = info?.address ?? " "
        self.phoneLabel.text = info?.cellPhone ?? " "
    }
    
    override func zt_rightBarButtonAction(_ sender: UIBarButtonItem!) {
        let info = WDLCoreManager.shared().userInfo
        let autheVC = AuthenEnterpriseVC()
        autheVC.zbnCarrierInfo = info
        self.pushToVC(vc: autheVC, title: "我的认证")
    }
}
