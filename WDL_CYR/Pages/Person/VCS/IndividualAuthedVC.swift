//
//  IndividualAuthedVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/6.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class IndividualAuthedVC: NormalBaseVC {
    
    @IBOutlet weak var handleImageView: UIImageView!
    @IBOutlet weak var oppositeImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var idCardLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func currentConfig() {
        let info = WDLCoreManager.shared().userInfo
        Util.showImage(imageView: self.handleImageView, imageUrl: info?.idCardHandheld, placeholder: self.handleImageView.image!)
        Util.showImage(imageView: self.frontImageView, imageUrl: info?.idCardFrontage, placeholder: self.frontImageView.image!)
        Util.showImage(imageView: self.oppositeImageView, imageUrl: info?.idCardOpposite, placeholder: self.oppositeImageView.image!)
        self.nameLabel.text = info?.carrierName ?? " "
        self.phoneLabel.text = info?.cellPhone ?? " "
        self.idCardLabel.text = info?.idCard ?? " "
    }
}
