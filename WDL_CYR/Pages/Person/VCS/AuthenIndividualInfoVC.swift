//
//  AuthenIndividualInfoVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//  认证成功界面

import UIKit
import RxSwift
import RxCocoa

class AuthenIndividualInfoVC: NormalBaseVC {
    
    enum AuthIndividualImageMode {
        case FrontImage     //身份证正面照
        case OppositeImage  //身份证背面照
        case WholeImage     //手持身份证
    }
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var IDCardTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    
    public var zbnCarrierInfo:ZbnCarrierInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHandleImageView()
    }
    
    override func currentConfig() {
        self.nameTextField.titleTextField(title: "姓名")
        self.mobileTextField.titleTextField(title: "电话")
        self.IDCardTextField.titleTextField(title: "身份证号")
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.5, radius: 2)
    }

    override func bindViewModel() {
        toInitInputInfo()
        if self.zbnCarrierInfo == nil {
            self.zbnCarrierInfo = ZbnCarrierInfo()
            self.zbnCarrierInfo?.carrierType = 1
        }
        self.nameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.carrierName = text
            })
            .disposed(by: dispose)
        self.mobileTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.cellPhone = text
            })
            .disposed(by: dispose)
        self.IDCardTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.zbnCarrierInfo?.idCard = text
            })
            .disposed(by: dispose)
    }
    
    //提交申请
    @IBAction func applyClick(_ sender: UIButton) {
        self.applyRequest()
    }
    
}

extension AuthenIndividualInfoVC{
    
    //MARK: - 提交数据
    func applyRequest() -> Void {
        if inputCarrerInfoIsOk() == true {
            self.showLoading()
            BaseApi.request(target: API.carrierIdentifer(self.zbnCarrierInfo!), type: BaseResponseModel<String>.self)
                .retry(5)
                .subscribe(onNext: { [weak self](data) in
                    self?.showSuccess(success: data.message, complete: {
                        self?.pop(toRootViewControllerAnimation: true)
                    })
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
                })
                .disposed(by: dispose)
        }
    }
    
    //MARK: - 验证数据有效性
    func inputCarrerInfoIsOk() -> Bool {
        if (self.zbnCarrierInfo?.carrierName?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写姓名", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.cellPhone?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写手机号码", complete: nil)
            return false
        }
        if (self.zbnCarrierInfo?.idCard?.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写身份证号码", complete: nil)
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
}

extension AuthenIndividualInfoVC {
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
    func uploadImage(image:UIImage , mode:AuthIndividualImageMode) -> Void {
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
    func uploadCardImageResult(imgUrl:String , mode:AuthIndividualImageMode) -> Void {
        switch mode {
        case .FrontImage:
            Util.showImage(imageView: self.frontImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
            self.zbnCarrierInfo?.idCardFrontage = imgUrl
            break
        case .OppositeImage:
            Util.showImage(imageView: self.backImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证-身份证")!)
            self.zbnCarrierInfo?.idCardOpposite = imgUrl
            break
        default:
            Util.showImage(imageView: self.handImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "我的认证- 手持身份证")!)
            self.zbnCarrierInfo?.idCardHandheld = imgUrl
            
        }
    }
    
    //MARK: - 变更数据时 ， 赋值初始值
    func toInitInputInfo() -> Void {
        let info = self.zbnCarrierInfo
        self.nameTextField.text = info?.carrierName
        self.IDCardTextField.text = info?.idCard
        self.mobileTextField.text = info?.cellPhone
        Util.showImage(imageView: self.frontImageView, imageUrl: info?.idCardFrontage, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
        Util.showImage(imageView: self.backImageView, imageUrl: info?.idCardOpposite, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
        Util.showImage(imageView: self.handImageView, imageUrl: info?.idCardHandheld, placeholder: UIImage.init(named: "我的认证-身份证人像页")!)
    }
}
