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
    
    enum AuthEnterpriseImageMode {
        case FrontImage     //身份证正面照
        case OppositeImage  //身份证背面照
        case WholeImage     //手持身份证
    }
    
    public var zbnCarrierInfo:ZbnCarrierInfo?
    
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
        self.initHandleImageView()

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
    
    override func bindViewModel() {
        toInitInputInfo()
        if self.zbnCarrierInfo == nil {
            self.zbnCarrierInfo = ZbnCarrierInfo()
            self.zbnCarrierInfo?.carrierType = 2
        }
        self.enterpriseNameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.companyName = text
            })
            .disposed(by: dispose)
        self.enterpriseSummerTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.companyAbbreviation = text
            })
            .disposed(by: dispose)
        self.legalNameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.legalPerson = text
            })
            .disposed(by: dispose)
        self.IDCardTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.idCard = text
            })
            .disposed(by: dispose)
        self.businesslicenseLabel.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.businessLicenseNo = text
            })
            .disposed(by: dispose)
        self.addressTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.address = text
            })
            .disposed(by: dispose)
        self.mobileTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.cellPhone = text
            })
            .disposed(by: dispose)
    }
    
    //提交申请
    @IBAction func applyClick(_ sender: UIButton) {
        if inputCarrerInfoIsOk() == true {
            self.applyRequest()
        }
    }
    
}

extension AuthenEnterpriseVC{
    //个人信息提交申请请求
    func applyRequest() -> Void {
        BaseApi.request(target: API.carrierIdentifer(self.zbnCarrierInfo!), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: {  [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.pop(toRootViewControllerAnimation: true)
                })
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //
    
}

//MARK: - 图片操作
extension AuthenEnterpriseVC {
    //MARK: - tap imageView
    func initHandleImageView() -> Void {
        self.frontImageView.singleTap { [weak self](_) in
            self?.takePhotoAlert(closure: { (img) in
                if let img = img {
                    self?.uploadImage(image: img, mode: .FrontImage)
                }
            })
        }
        self.backImageView.singleTap { [weak self](_) in
            self?.takePhotoAlert(closure: { (img) in
                if let img = img {
                    self?.uploadImage(image: img, mode: .OppositeImage)
                }
            })
        }
        self.handImageView.singleTap { [weak self](_) in
            self?.takePhotoAlert(closure: { (img) in
                if let img = img {
                    self?.uploadImage(image: img, mode: .WholeImage)
                }
            })
        }
    }
    
    //MARK: - 上传z图片
    func uploadImage(image:UIImage , mode:AuthEnterpriseImageMode) -> Void {
        self.showLoading()
        BaseApi.request(target: API.uploadImage(image, .card_path), type: BaseResponseModel<[String]>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.uploadCardImageResult(imgUrl: data.data?.first ?? "", mode: mode)
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - s图片上传成功后的操作
    func uploadCardImageResult(imgUrl:String , mode:AuthEnterpriseImageMode) -> Void {
        switch mode {
        case .FrontImage:
            Util.showImage(imageView: self.frontImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证-身份证")!)
            self.zbnCarrierInfo?.idCardFrontage = imgUrl
            break
        case .OppositeImage:
            Util.showImage(imageView: self.backImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
            self.zbnCarrierInfo?.idCardOpposite = imgUrl
            break
        default:
            Util.showImage(imageView: self.handImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证- 手持身份证")!)
            self.zbnCarrierInfo?.idCardHandheld = imgUrl
            
        }
    }
    
    //MARK: - 验证数据有效性
    func inputCarrerInfoIsOk() -> Bool {
        if (self.zbnCarrierInfo?.companyName?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写企业名称", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.companyAbbreviation?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写企业简称", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.legalPerson?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写法人姓名", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.idCard?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写身份证号码", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.businessLicenseNo?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写营业执照号", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.address?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写联系地址", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.cellPhone?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写联系电话", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.idCardFrontage?.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传身份证正面照", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.idCardOpposite?.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传身份证背面照", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.idCardHandheld?.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传手持身份证照片", complete: nil)
            return false
        }
        return true
    }
    
    //MARK: - 变更数据时 ， 赋值初始值
    func toInitInputInfo() -> Void {
        let info = self.zbnCarrierInfo
        self.enterpriseNameTextField.text = info?.companyName
        self.enterpriseSummerTextField.text = info?.companyAbbreviation
        self.legalNameTextField.text = info?.legalPerson
        self.IDCardTextField.text = info?.idCard
        self.businesslicenseLabel.text = info?.businessLicenseNo
        self.addressTextField.text = info?.address
        self.mobileTextField.text = info?.cellPhone
        Util.showImage(imageView: self.frontImageView, imageUrl: info?.idCardFrontage, placeholder: UIImage.init(named: "我的认证-身份证")!)
        Util.showImage(imageView: self.backImageView, imageUrl: info?.idCardOpposite, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
        Util.showImage(imageView: self.handImageView, imageUrl: info?.idCardHandheld, placeholder: UIImage.init(named: "我的认证- 手持身份证")!)
    }
}
