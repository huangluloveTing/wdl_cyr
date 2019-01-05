//
//  PathDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//  关注路线详情页

import UIKit

class PathDetailVC: AttentionDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var lineHall:FollowFocusLineOrderHallResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: self.tableView)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
         self.getFouceLineCarrierById()//数据请求刷新
    }
    
    
    // 获取关注的托运人下面的货源
    func getFouceLineCarrierById() -> Void {
        //托运人编码
        var cancelQuery = CancerFouceCarrier()
        cancelQuery.code = self.lineHall.lineCode ?? ""
        self.showLoading()
        BaseApi.request(target: API.getFoucesLineOrderById(cancelQuery), type:
            BaseResponseModel<PageInfo<CarrierQueryOrderHallResult>>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
                self?.lineHall.hall = data.data?.list ?? []
                self?.configResources()
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    
    override func pageTitle() -> String? {
        let start = (self.lineHall.startProvince ?? "") + (self.lineHall.startCity ?? "")
        let end = (self.lineHall.endProvince ?? "") + (self.lineHall.endCity ?? "")
        return start + "-" + end
    }
    
    func configResources() -> Void {
        let items = self.lineHall.hall.map { (res) -> ResourceHallUIModel in
            let truckInfo = Util.dateFormatter(date: res.loadingTime/1000, formatter: "MM-dd") + " 装货 " + res.goodsType
            let goodsInfo = Util.contact(strs: [String(format: "%.3f", res.goodsWeight)+"吨" , res.vehicleLength , res.vehicleType , res.packageType], seperate: " | ")
            
            //关注按钮
            //   var shipperCode : String = "" // (string): 字段不为空表示托运人关注 ,
            // var followLine : Bool = true;//关注路线true ，未关注false
            let model = ResourceHallUIModel(id: res.id,start: res.startProvince + res.startCity,
                                            end: res.endProvince + res.endCity,
                                            truckInfo: truckInfo,
                                            goodsInfo: goodsInfo,
                                            isSelf: true,
                                            company: res.consignorName,
                                            isAttention: res.shipperCode.count > 0,
                                            unitPrice: res.dealUnitPrice,
                                            companyLogo: res.companyLogo,
                                            reportNum: res.offerNumber,
                                            refercneceUnitPrice: res.refercneceUnitPrice,
                                            refercnecePriceIsVisable: res.refercnecePriceIsVisable,
                                            isOffer:(res.isOffer != nil && (res.isOffer)!.count > 0),
                                            shipperCode:res.shipperCode,
                                            followLine:res.followLine)
            return model
        }
        self.refresh(items: items)
    }
    
    override func tapItemAtIndex(index: Int) {
        self.toResourceHallDetail(index: index)
    }
    
    override func toOfferAtIndex(index: Int) {
        var resource = ResourceDetailUIModel()
        let hall = self.lineHall.hall[index]
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
//        resource.carrierName = hall.consigneeName
        resource.consignorName = hall.consignorName
        resource.resource = hall
        resource.attention = hall.shipperCode.count > 0
        self.toChooseOfferType(resource: resource)
    }
    
    // 货源详情
    func toResourceHallDetail(index:Int) -> Void {
        var resource = ResourceDetailUIModel()
        let hall = self.lineHall.hall[index]
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
        resource.attention = hall.shipperCode.count > 0
//        resource.carrierName = hall.consigneeName
        resource.consignorName = hall.consignorName
        resource.resource = hall
        self.toResouceDetail(resource: resource)
    }
    
    override func callBackForRefresh(param: Any?) {
        super.callBackForRefresh(param: param)
        let info = param as! CarrierQueryOrderHallResult
        var newHalls = self.lineHall.hall
        self.lineHall.hall.enumerated().forEach { (offset, element) in
            if element.id == info.id {
                newHalls[offset] = info
            }
        }
        self.lineHall.hall = newHalls
        self.configResources()
    }
}
