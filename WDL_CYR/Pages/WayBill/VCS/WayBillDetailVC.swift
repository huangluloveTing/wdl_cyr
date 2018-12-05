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
    
    public var transportNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView(tableView: tableView)
        self.loadDetailData(hallId: self.waybillInfo?.hallId ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func currentConfig() {
        
    }
    
    
    override func toCommitComment() {
        let assembleVC = WaybillAssembleVC()
        assembleVC.pageInfo = currentWaybillDetailInfo()
        assembleVC.currentDisplayMode = .driverAssemble
        self.pushToVC(vc: assembleVC, title: "配载")
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
    }
}

extension WayBillDetailVC {
    //MARK: - 上传运单
    func uploadWaybillImage(image:UIImage?) -> Void {
        guard let newImg = image else {
            return
        }
        BaseApi.request(target: API.uploadImage(newImg, .returnbill_path), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { (data) in
                
            }, onError: { (error) in
                
            })
            .disposed(by: dispose)
    }
}
