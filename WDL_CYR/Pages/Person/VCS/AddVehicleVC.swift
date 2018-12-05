//
//  AddVehicleVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class AddVehicleVC: NormalBaseVC {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func currentConfig() {
        bottomView.shadow(color: UIColor(hex: "000000"), offset: CGSize(width: 0, height: -2), opacity: 0.3, radius: 2)
        initTextField()
        initHandlePictureView()
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
            break
        case .insuranceLicense:
            Util.showImage(imageView: self.insuranceImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_ins")!)
            break
        default:
            Util.showImage(imageView: self.vehicleImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_vehi")!)
        }
    }
}

extension AddVehicleVC {
    //MARK: - init views
    func initTextField() -> Void {
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
}
