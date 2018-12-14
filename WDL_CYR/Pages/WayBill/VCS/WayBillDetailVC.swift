//
//  WayBillDetailVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/1.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class WayBillDetailVC: WaybillDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var commentModel:ToCommentModel?
    
    public var transportNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView(tableView: tableView)
        self.loadDetailData(hallId: self.waybillInfo?.hallId ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func currentConfig() {
        
    }
    
    
    override func toCommitComment() {
        var evaluate = ZbnEvaluateVo()
        evaluate.evaluateTo = 2
        evaluate.transportNo = transportNo ?? ""
        evaluate.logisticsServicesScore = Int(self.commentModel?.logicRate ?? 0)
        evaluate.serviceAttitudeScore = Int(self.commentModel?.serviceRate ?? 0)
        evaluate.commonts = self.commentModel?.comment ?? ""
        if evaluate.logisticsServicesScore == 0 {
            self.showWarn(warn: "请评价物流服务", complete: nil)
            return
        }
        if evaluate.serviceAttitudeScore == 0 {
            self.showWarn(warn: "请评价服务态度", complete: nil)
            return
        }
        self.showLoading()
        BaseApi.request(target: API.createEvaluate(evaluate), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: "评价成功", complete: {
                    self?.pop(toRootViewControllerAnimation: true)
                })
                }, onError: { (error) in
                    self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    override func toComment(comment: ToCommentModel) {
        self.commentModel = comment;
    }
    
    override func clickAddReturn() {
        self.takePhotoAlert { [weak self](image) in
            self?.uploadWaybillImage(image: image)
        }
    }
    
    override func clickReturnList(index: Int) {
        
    }
    
    override func handleAction() {
        //MARK: - 指派
        let mode = currentMode()
        if mode == .unassemble_showDesignate {
            self.toChooseDriver(title: "选择司机", closure: { [weak self](capacity) in
                let phone = capacity.driverPhone
                let code = self?.waybillInfo?.transportId ?? ""
                let hallId = self?.waybillInfo?.hallId ?? ""
                self?.toDesignate(phone: phone, transportNo: code , hallId: hallId, closure: {
                    self?.showSuccess(success: "指派成功", complete: {
                        self?.loadDetailData(hallId: hallId)
                    })
                })
            })
        }
        if mode == .unassemble_showSpecial ||
            mode == .unassemble_show_1_Assemble ||
            mode == .unassemble_show_2_Assemble {
            let tranInfo = TransactionInformation.deserialize(from: self.waybillInfo?.toJSON())
            let mode = WayBillSourceTypeMode(rawValue: self.waybillInfo?.comeType ?? 1)
            self.toAssemblePage(info: tranInfo , mode: mode ?? .planAssemble)
        }
    }
}

extension WayBillDetailVC {
    //MARK: - 上传运单
    func uploadWaybillImage(image:UIImage?) -> Void {
        guard let newImg = image else {
            return
        }
        self.showLoading()
        BaseApi.request(target: API.uploadImage(newImg, .returnbill_path), type: BaseResponseModel<[String]>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.addReturnBill(imgURL: data.data?.first ?? "")
//                self?.uploadReturnImgToTransport(img: data.data?.first ?? "")
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 上传运单到运单数据中
    func uploadReturnImgToTransport(img:String) -> Void {
        let transportNo = self.waybillInfo?.transportNo ?? ""
        BaseApi.request(target: API.updateReturnImg(img, transportNo), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.addReturnBill(imgURL: img)
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
}
