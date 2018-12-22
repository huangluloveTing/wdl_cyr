//
//  AddVehicleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddVehicleVC: NormalBaseVC {
    
    public var currentCommitItem:ZbnTransportCapacity? // 当前提交车辆编辑提交数据
    
    public var editStatus:Bool = false
    
    private var typeModels:HallModels?
    
    enum AddVehicleHandleMode {
        case driverLicense      // 行驶证
        case insuranceLicense   // 保险单
        case vehicleImage       // 货车照片
    }
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var vehicleNoTextField: UITextField!     // 车牌号码
    @IBOutlet weak var vehicleTypeTextField: UITextField!   // 车辆类型
    @IBOutlet weak var ownTextField: UITextField!           // 所有人
    @IBOutlet weak var addressTextField: UITextField!       // 住址
    @IBOutlet weak var useTypeTextField: UITextField!       // 使用性质
    @IBOutlet weak var vehicleIdTextField: UITextField!     // 车辆识别号
    @IBOutlet weak var vehicleEnginNoTextField: UITextField!// 发动机号码
    
    @IBOutlet weak var registerTextField: UITextField!      // 注册日期
    @IBOutlet weak var checkValidTextField: UITextField!    // 检验有效期
    @IBOutlet weak var insValidTextField: UITextField!      // 保险有效期
    
    @IBOutlet weak var volumnTextField: UITextField!        // 体积
    @IBOutlet weak var lengthTextField: UITextField!        // 长度
    @IBOutlet weak var weightTextField: UITextField!        // 载重
    
    
    @IBOutlet weak var driverLicesImageView: UIImageView!   // 行驶证
    @IBOutlet weak var insuranceImageView: UIImageView!     // 保险单
    @IBOutlet weak var vehicleImageView: UIImageView!       // 货车照片
    @IBOutlet weak var vehichleWidthTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVehicleType()
    }

    override func currentConfig() {
        bottomView.shadow(color: UIColor(hex: "000000"), offset: CGSize(width: 0, height: -2), opacity: 0.3, radius: 2)
        initTextField()
        initHandlePictureView()
    }
    
    @IBAction func commitHandle(_ sender: Any) {
        commitVehicleInfo()
    }
    override func bindViewModel() {
        self.registerTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.registrationDate = date * 1000
            })
            .disposed(by: dispose)
        self.insValidTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.insuranceExpirationDate = date * 1000
            })
            .disposed(by: dispose)
        self.checkValidTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.inspectionValidityDate = date * 1000
            })
            .disposed(by: dispose)
        
        self.vehicleNoTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleNo = text
            })
            .disposed(by: dispose)
        self.vehicleTypeTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleType = text
            })
            .disposed(by: dispose)
        self.ownTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.belongToCarrier = text
            })
            .disposed(by: dispose)
        self.addressTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.address = text
            })
            .disposed(by: dispose)
        self.useTypeTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.useProperty = text
            })
            .disposed(by: dispose)
        self.vehicleIdTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleIdCode = text
            })
            .disposed(by: dispose)
        self.vehicleEnginNoTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.engineNumber = text
            })
            .disposed(by: dispose)
        self.volumnTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleVolume = text
            })
            .disposed(by: dispose)
        self.lengthTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleLength = text
            })
            .disposed(by: dispose)
        self.weightTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleWeight = text
            })
            .disposed(by: dispose)
        self.vehichleWidthTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.vehicleWidth = text
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 判断是否是编辑
    func currentIsEditVehicle() -> Bool {
        if self.currentCommitItem == nil { // 当当前编辑对象为 nil , 即为添加新车辆 ， 返回false
            return false
        }
        return true
    }
}

extension AddVehicleVC {
    //MARK: - 验证提交信息
    func commitIsOk() -> Bool {
        if (self.currentCommitItem?.vehicleNo.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入车辆号码", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehicleType.count ?? 0) <= 0 {
            self.showWarn(warn: "请选择车辆类型", complete: nil)
            return false
        }
        if (self.currentCommitItem?.belongToCarrier.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入车辆所有人", complete: nil)
            return false
        }
        if (self.currentCommitItem?.address.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入住址", complete: nil)
            return false
        }
        if (self.currentCommitItem?.useProperty.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入使用性质", complete: nil)
            return false
        }
        if (self.currentCommitItem?.engineNumber.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入车辆号码", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehicleIdCode.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入车辆号码", complete: nil)
            return false
        }
        
        if (self.currentCommitItem?.registrationDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择注册日期", complete: nil)
            return false
        }
        if (self.currentCommitItem?.inspectionValidityDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择检验有效期", complete: nil)
            return false
        }
        if (self.currentCommitItem?.insuranceExpirationDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择保险到期日期", complete: nil)
            return false
        }
        
        if (self.currentCommitItem?.vehicleVolume.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写车辆体积", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehicleLength.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写车辆长度", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehicleWeight.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写车辆载重", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehicleWidth.count ?? 0) <= 0 {
            self.showWarn(warn: "请填写车辆宽度", complete: nil)
            return false
        }
        
        if (self.currentCommitItem?.drivingLicensePhoto.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传行驶证照片", complete: nil)
            return false
        }
        if (self.currentCommitItem?.insurancePhoto.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传保险单照片", complete: nil)
            return false
        }
        if (self.currentCommitItem?.vehiclePhoto.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传车辆照片", complete: nil)
            return false
        }
        return true
    }
}

extension AddVehicleVC {
    //MARK: - 上传图片
    func uploadPictureToServer(image:UIImage , mode:AddVehicleHandleMode) -> Void {
        self.showLoading()
        BaseApi.request(target: API.uploadImage(image, UploadImagTypeMode.license_path), type: BaseResponseModel<[String]>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                let imgUrl = data.data?.first ?? ""
                self?.uploadSuccessResulthandle(mode: mode, imgUrl: imgUrl)
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - upload result handle
    func uploadSuccessResulthandle(mode:AddVehicleHandleMode , imgUrl:String) -> Void {
        switch mode {
        case .driverLicense:
            Util.showImage(imageView: self.driverLicesImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_vehi_liens")!)
            self.currentCommitItem?.drivingLicensePhoto = imgUrl
            break
        case .insuranceLicense:
            Util.showImage(imageView: self.insuranceImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_ins")!)
            self.currentCommitItem?.insurancePhoto = imgUrl
            break
        default:
            Util.showImage(imageView: self.vehicleImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_vehi")!)
            self.currentCommitItem?.vehiclePhoto = imgUrl
        }
    }
    
    //MARK: - 配载车辆类型数据
    func toConfigVehicleTypeData() -> [String] {
        var items : [String] = []
        self.typeModels?.VehicleType?.forEach({ (item) in
            items.append(item.dictionaryName ?? " ")
        })
        return items
    }
    
    //MARK: - 提交车辆信息
    func commitVehicleInfo() -> Void {
        if commitIsOk() == true {
            self.showLoading()
            BaseApi.request(target: API.addCapacityInformation((self.currentCommitItem)!), type: BaseResponseModel<String>.self)
                .retry(5)
                .subscribe(onNext: { [weak self](data) in
                    self?.showSuccess(success: data.message, complete: {
                        self?.pop()
                    })
                } ,onError: {[weak self] (error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
                })
                .disposed(by: dispose)
        }
    }
    
    //MARK: - 获取车辆类型
    func loadVehicleType() -> Void {
        BaseApi.request(target: API.dictionaryEntityByCode(BasicDictionaryKeyMode.VehicleType), type: BaseResponseModel<HallModels>.self)
            .retry()
            .subscribe(onNext: { [weak self](data) in
                self?.typeModels = data.data
                self?.vehicleTypeTextField.oneChooseInputView(titles: self?.toConfigVehicleTypeData())
                    .disposed(by: self?.dispose ?? DisposeBag())
            })
            .disposed(by: dispose)
    }
}

extension AddVehicleVC {
    //MARK: - init views
    func initTextField() -> Void {
        toInitInputContent()
        if self.currentCommitItem == nil {
            self.currentCommitItem = ZbnTransportCapacity()
        }
        self.vehicleNoTextField.titleTextField(title: "  车辆号码")
        self.vehicleTypeTextField.titleTextField(title: "  车辆类型" , indicator: true)
        self.ownTextField.titleTextField(title: "  所有人")
        self.addressTextField.titleTextField(title: "  住址")
        self.useTypeTextField.titleTextField(title: "  使用性质")
        self.vehicleIdTextField.titleTextField(title: "  车辆识别代码")
        self.vehicleEnginNoTextField.titleTextField(title: "  发动机号码")
        
        self.registerTextField.titleTextField(title: "  注册日期" , indicator: true)
        self.checkValidTextField.titleTextField(title: "  检验有效期" , indicator: true)
        self.insValidTextField.titleTextField(title: "  保险到期时间" , indicator: true)
        
        self.volumnTextField.titleTextField(title: "  体积")
        self.lengthTextField.titleTextField(title: "  车长")
        self.weightTextField.titleTextField(title: "  载重")
        self.vehichleWidthTextField.titleTextField(title: "  车宽")
    }
    
    func initHandlePictureView() -> Void {
        self.driverLicesImageView.singleTap { [weak self](_) in
            self?.takePhotoAlert(closure: {(image) in
                if image == nil {
                    return
                }
                self?.uploadPictureToServer(image: image!, mode: .driverLicense)
            })
        }
        self.insuranceImageView.singleTap {[weak self] (_) in
            self?.takePhotoAlert(closure: { (image) in
                if image == nil {
                    return
                }
                self?.uploadPictureToServer(image: image!, mode: .insuranceLicense)
            })
        }
        self.vehicleImageView.singleTap {[weak self] (_) in
            self?.takePhotoAlert(closure: { (image) in
                if image == nil {
                    return
                }
                self?.uploadPictureToServer(image: image!, mode: .vehicleImage)
            })
        }
    }
    
    //MARK: - 编辑时 ，初始数据
    func toInitInputContent() -> Void {
        self.vehicleNoTextField.text = self.currentCommitItem?.vehicleNo
        self.vehicleTypeTextField.text = self.currentCommitItem?.vehicleType
        self.ownTextField.text = self.currentCommitItem?.belongToCarrier
        self.addressTextField.text = self.currentCommitItem?.address
        self.useTypeTextField.text = self.currentCommitItem?.useProperty
        self.vehicleIdTextField.text = self.currentCommitItem?.vehicleIdCode
        self.vehicleEnginNoTextField.text = self.currentCommitItem?.engineNumber
        
        if (self.currentCommitItem?.registrationDate ?? 0) > 0 {
            self.registerTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.registrationDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        if (self.currentCommitItem?.inspectionValidityDate ?? 0) > 0 {
            self.checkValidTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.inspectionValidityDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        if (self.currentCommitItem?.insuranceExpirationDate ?? 0) > 0 {
            self.insValidTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.insuranceExpirationDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        self.volumnTextField.text = self.currentCommitItem?.vehicleVolume
        self.lengthTextField.text = self.currentCommitItem?.vehicleLength
        self.weightTextField.text = self.currentCommitItem?.vehicleWeight
        self.vehichleWidthTextField.text = self.currentCommitItem?.vehicleWidth
        
        Util.showImage(imageView: self.driverLicesImageView, imageUrl: self.currentCommitItem?.drivingLicensePhoto, placeholder: UIImage.init(named: "add_vehi_liens")!)
        Util.showImage(imageView: self.insuranceImageView, imageUrl: self.currentCommitItem?.insurancePhoto, placeholder: UIImage.init(named: "add_ins")!)
        Util.showImage(imageView: self.vehicleImageView, imageUrl: self.currentCommitItem?.vehiclePhoto, placeholder: UIImage.init(named: "add_vehi")!)
    }
}
