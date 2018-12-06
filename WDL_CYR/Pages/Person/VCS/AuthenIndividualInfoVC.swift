//
//  AuthenIndividualInfoVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift

class AuthenIndividualInfoVC: NormalBaseVC {
    
    private var infoDispose:Disposable? = nil
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var IDCardTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func currentConfig() {
        self.nameTextField.titleTextField(title: "姓名")
        self.mobileTextField.titleTextField(title: "电话")
        self.IDCardTextField.titleTextField(title: "身份证号")
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.5, radius: 2)
    }

    override func bindViewModel() {
        
    }
    
    //提交申请
    @IBAction func applyClick(_ sender: UIButton) {
        self.applyRequest()
    }
    
}

extension AuthenIndividualInfoVC{
//个人信息提交申请请求
func applyRequest() -> Void {
    var query = ZbnCarrierInfo()
    query.carrierType = 1//个人
    query.legalPersonPhone = self.mobileTextField.text//手机号必须是法人字段，不然会覆盖
    query.carrierName = self.nameTextField.text
    query.idCard = self.IDCardTextField.text
    //图片
    self.infoDispose = BaseApi.request(target: API.carrierIdentifer(query), type: BaseResponseModel<Any>.self)
        .subscribe(onNext: { [weak self](data) in
            self?.showSuccess(success: data.message, complete: {
                self?.pop(toRootViewControllerAnimation: true)
            })
            }, onError: { [weak self](error) in
                                self?.showFail(fail: error.localizedDescription, complete: nil)
        })
    }

}
