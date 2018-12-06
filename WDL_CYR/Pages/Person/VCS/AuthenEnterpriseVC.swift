//
//  AuthenEnterpriseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//  公司认证申请

import UIKit
import RxSwift
class AuthenEnterpriseVC: NormalBaseVC {
    
    private var infoDispose:Disposable? = nil
    @IBOutlet weak var enterpriseNameTextField: UITextField!
    @IBOutlet weak var enterpriseSummerTextField: UITextField!
    @IBOutlet weak var legalNameTextField: UITextField!
    @IBOutlet weak var IDCardTextField: UITextField!
    @IBOutlet weak var businesslicenseLabel: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func currentConfig() {
        self.enterpriseNameTextField.titleTextField(title: "企业名称")
        self.enterpriseSummerTextField.titleTextField(title: "企业简称")
        self.legalNameTextField.titleTextField(title: "法人姓名")
        self.IDCardTextField.titleTextField(title: "身份证号码")
        self.businesslicenseLabel.titleTextField(title: "营业执照")
        self.addressTextField.titleTextField(title: "联系地址")
        self.mobileTextField.titleTextField(title: "联系电话")
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.5, radius: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //提交申请
    @IBAction func applyClick(_ sender: UIButton) {
        self.applyRequest()
    }
    
}

extension AuthenEnterpriseVC{
    //个人信息提交申请请求
    func applyRequest() -> Void {
        var query = ZbnCarrierInfo()
        query.carrierType = 2//企业
        query.legalPersonPhone = self.mobileTextField.text//手机号必须是法人字段，不然会覆盖
         query.legalPerson = self.legalNameTextField.text//法人姓名
        query.companyName = self.enterpriseNameTextField.text//企业名称
         query.companyAbbreviation = self.enterpriseSummerTextField.text//企业简介
        query.businessLicenseNo = self.businesslicenseLabel.text
       //营业执照号
        query.idCard = self.IDCardTextField.text
        
        query.address = self.addressTextField.text//联系地址
        //图片
        
        self.infoDispose = BaseApi.request(target: API.carrierIdentifer(query), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: {  [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop(toRootViewControllerAnimation: true)
                })
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
    }
    
}

