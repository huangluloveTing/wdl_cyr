//
//  FirstAddDriverListVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/26.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class FirstAddDriverListVC: NormalBaseVC {
    public var currentCommitItem:ZbnTransportCapacity? // 当前提交司机编辑提交数据

    private var typeModels:HallModels?
    
    enum AddVehicleHandleMode {
        case driverLicense      // 行驶证
    }
    
    var selectedBtn: UIButton = UIButton()//选中的按钮
    var isEidt: Bool = false// 是修改true 还是添加false
    //提交的背景图片
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!     // 姓名
    @IBOutlet weak var nationTextField: UITextField!   // 国籍
   
    @IBOutlet weak var addressTextField: UITextField!       // 住址
   
    @IBOutlet weak var bornDateTextField: UITextField!    // 出生日期
    @IBOutlet weak var getLisenseDateTextField: UITextField!      // 初次领证日期
    
    @IBOutlet weak var canDriverCarTypeTextField: UITextField!       // 准驾车型
    @IBOutlet weak var startDateTextField: UITextField!     // 开始日期
    @IBOutlet weak var endDateTextField: UITextField!// 结束日期
    
    @IBOutlet weak var driverNumberTextField: UITextField!      // 驾驶证号

    @IBOutlet weak var fileTextField: UITextField!        // 档案编号

    @IBOutlet weak var driverLicesImageView: UIImageView!   // 行驶证
    //男
    @IBOutlet weak var manBtn: UIButton!
    //女
    @IBOutlet weak var womanBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //新添加
        if isEidt == false {
            //默认选中男
            self.sexClick(self.manBtn)
        }
        
    }
    
    override func currentConfig() {
        bottomView.shadow(color: UIColor(hex: "000000"), offset: CGSize(width: 0, height: -2), opacity: 0.3, radius: 2)
        //设置textfield 的左边title
        initTextField()
        //点击选中图片
        initHandlePictureView()
    }
    //提交
    @IBAction func commitHandle(_ sender: Any) {
        //新添加
        if isEidt == false {
            //新添加
            self.currentCommitItem?.id = ""
          
            //提交请求
            commitAddNewDriverInfo()
        }else{
            //提交请求
            commitEditDriverInfo()
        }
        
    }
    
    
    //MARK: - 添加新的做自己提交驾驶员信息
    func commitAddNewDriverInfo() -> Void {
        if commitIsOk() == true {
            self.showLoading()
            BaseApi.request(target: API.addDriverOwn((self.currentCommitItem)!), type: BaseResponseModel<String>.self)
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
    
    //MARK: - 修改编辑提交驾驶员信息
    func commitEditDriverInfo() -> Void {
        if commitIsOk() == true {
            self.showLoading()
            BaseApi.request(target: API.editOrModifyDriverOwn((self.currentCommitItem)!), type: BaseResponseModel<String>.self)
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
    //性别二选一（55 男 56女）//"1" 男 "0" 女
    @IBAction func sexClick(_ sender: UIButton) {
        
        if sender != self.selectedBtn {
            self.selectedBtn.isSelected = false;
            sender.isSelected = true;
            self.selectedBtn = sender;
        }else{
            self.selectedBtn.isSelected = true;
        }
        if sender.tag == 55 {
            self.currentCommitItem?.gender = "1"
        }else{
            self.currentCommitItem?.gender = "0"
        }
        
    }
    
    
    override func bindViewModel() {
        
        //开始日期
        self.startDateTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                    self?.currentCommitItem?.driverLecenseStartDate = date * 1000
            })
            .disposed(by: dispose)
        //结束日期
        self.endDateTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.driverLecenseEndDate = date * 1000
            })
            .disposed(by: dispose)
        //出生日期
        self.bornDateTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.birdthDay = date * 1000
            })
            .disposed(by: dispose)
        //初次领证日期
        self.getLisenseDateTextField.datePickerInput(mode: .date, dateFormatter: "yyyy-MM-dd", skip: 1)
            .asObservable()
            .subscribe(onNext: { [weak self](date) in
                self?.currentCommitItem?.initialLicenseDate = date * 1000
            })
            .disposed(by: dispose)
    
        
        //姓名
        self.nameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.driverName = text
            })
            .disposed(by: dispose)
        
        //国籍
        self.nationTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.nationality = text
            })
            .disposed(by: dispose)
        //住址
        self.addressTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.address = text
            })
            .disposed(by: dispose)
        //准驾车型
        self.canDriverCarTypeTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.quasiDrivingModel = text
            })
            .disposed(by: dispose)
        //驾驶证号
        self.driverNumberTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.driverFileNo = text
            })
            .disposed(by: dispose)
        //档案编号
        self.fileTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.currentCommitItem?.driverArchivesNo = text
            })
            .disposed(by: dispose)
    
    }
    
   
}

extension FirstAddDriverListVC {
    //MARK: - 验证提交信息
    func commitIsOk() -> Bool {
        if (self.currentCommitItem?.driverName.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入姓名", complete: nil)
            return false
        }
        if (self.currentCommitItem?.nationality.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入国籍", complete: nil)
            return false
        }
      
        if (self.currentCommitItem?.address.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入住址", complete: nil)
            return false
        }
      
        if (self.currentCommitItem?.birdthDay ?? 0) <= 0 {
            self.showWarn(warn: "请选择出生日期", complete: nil)
            return false
        }
        if (self.currentCommitItem?.initialLicenseDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择初次领证日期", complete: nil)
            return false
        }
        if (self.currentCommitItem?.quasiDrivingModel.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入驾驶证准驾车型", complete: nil)
            return false
        }
        if (self.currentCommitItem?.driverLecenseStartDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择检验有效的开始日期", complete: nil)
            return false
        }
        if (self.currentCommitItem?.driverLecenseEndDate ?? 0) <= 0 {
            self.showWarn(warn: "请选择检验有效的结束日期", complete: nil)
            return false
        }
        
        if (self.currentCommitItem?.driverArchivesNo.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入驾驶证证号", complete: nil)
            return false
        }
        if (self.currentCommitItem?.driverFileNo.count ?? 0) <= 0 {
            self.showWarn(warn: "请输入驾驶证档案编号", complete: nil)
            return false
        }
       
        if (self.currentCommitItem?.drivingLicensePhoto.count ?? 0) <= 0 {
            self.showWarn(warn: "请上传行驶证照片", complete: nil)
            return false
        }
       
        return true
    }
}

extension FirstAddDriverListVC {
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
        Util.showImage(imageView: self.driverLicesImageView, imageUrl: imgUrl, placeholder: UIImage.init(named: "add_vehi_liens")!)
        self.currentCommitItem?.drivingLicensePhoto = imgUrl
    }


    
}

extension FirstAddDriverListVC {
    //MARK: - init views
    func initTextField() -> Void {
        //初始数据
        toInitInputContent()
        if self.currentCommitItem == nil {
            self.currentCommitItem = ZbnTransportCapacity()
        }
        self.nameTextField.titleTextField(title: "  姓名")
        self.nationTextField.titleTextField(title: "  国籍")
        self.addressTextField.titleTextField(title: "  住址")
        self.bornDateTextField.titleTextField(title: "  出生日期" , indicator: true)
        self.getLisenseDateTextField.titleTextField(title: "  初次领证日期" , indicator: true)
        self.canDriverCarTypeTextField.titleTextField(title: "  准驾车型")
        self.driverNumberTextField.titleTextField(title: "  证号")
        self.fileTextField.titleTextField(title: "  档案编号")
        
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
      
    }
    
    //MARK: - 编辑时 ，初始数据
    func toInitInputContent() -> Void {
        self.nameTextField.text = self.currentCommitItem?.driverName
        self.nationTextField.text = self.currentCommitItem?.nationality
        self.addressTextField.text = self.currentCommitItem?.address
        //性别
        if self.currentCommitItem?.gender == "1"{
            //男
            self.sexClick(self.manBtn)
            
        }else{
            //女
    
            self.sexClick(self.womanBtn)
        }
        

        if (self.currentCommitItem?.birdthDay ?? 0) > 0 {
            self.bornDateTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.birdthDay ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        //初次领证日期
        if (self.currentCommitItem?.initialLicenseDate ?? 0) > 0 {
            self.getLisenseDateTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.initialLicenseDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        //开始日期和结束日期
        if (self.currentCommitItem?.driverLecenseStartDate ?? 0) > 0 {
            self.startDateTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.driverLecenseStartDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        if (self.currentCommitItem?.driverLecenseEndDate ?? 0) > 0 {
            self.endDateTextField.text = Util.dateFormatter(date: (self.currentCommitItem?.driverLecenseEndDate ?? 0) / 1000, formatter: "yyyy-MM-dd")
        }
        //准驾车型
        self.canDriverCarTypeTextField.text = self.currentCommitItem?.quasiDrivingModel
        //驾驶证编号
        self.driverNumberTextField.text = self.currentCommitItem?.driverFileNo
        //档案编号
        self.fileTextField.text = self.currentCommitItem?.driverArchivesNo
     

        Util.showImage(imageView: self.driverLicesImageView, imageUrl: self.currentCommitItem?.drivingLicensePhoto, placeholder: UIImage.init(named: "add_vehi_liens")!)
     
    }
}
