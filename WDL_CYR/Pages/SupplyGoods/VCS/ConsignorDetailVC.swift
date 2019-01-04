//
//  ConsignorDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//  关注托运人详情

import UIKit

class ConsignorDetailVC: AttentionDetailBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var followShipper:FollowShipperOrderHall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: tableView)
        self.configResources()
    }
    
    override func pageTitle() -> String? {
        return self.followShipper.consignorName
    }
    // 获取关注的托运人下面的货源
 
    func getFouceCarrierById(code: String) -> Void {
        //托运人编码
        var cancelQuery = CancerFouceCarrier()
        cancelQuery.code = code
        self.showLoading()
        BaseApi.request(target: API.getFoucesOrderById(cancelQuery), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
           
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    func configResourceInfos() -> [ResourceHallUIModel] {
        let items = self.followShipper.hall.map { (res) -> ResourceHallUIModel in
            let truckInfo = Util.dateFormatter(date: res.loadingTime/1000, formatter: "MM-dd") + " 装货 " + res.goodsType
            let goodsInfo = Util.contact(strs: [String(format: "%.f", res.goodsWeight)+"吨" , res.vehicleLength , res.vehicleType , res.packageType], seperate: " | ")
            
           
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
                                            refercneceUnitPrice:res.refercneceUnitPrice ,
                                            refercnecePriceIsVisable: res.refercnecePriceIsVisable,
                                            isOffer:(res.isOffer != nil  && (res.isOffer)!.count > 0),
                                            shipperCode:res.shipperCode,
                                            followLine:res.followLine)
            
            
            
            return model
        }
        return items
    }
    
    func configResources() -> Void {
        let items = configResourceInfos()
        self.refresh(items: items)
    }
    
    override func tapItemAtIndex(index: Int) {
        self.toResourceHallDetail(index: index)
    }
    
    override func toOfferAtIndex(index: Int) {
        var resource = ResourceDetailUIModel()
        let hall = self.followShipper.hall[index]
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
//        resource.carrierName = hall.consignorName
        resource.consignorName = hall.consignorName
        resource.resource = hall
        resource.attention = hall.shipperCode.count > 0
        self.toChooseOfferType(resource: resource)
    }
    
    // 货源详情
    func toResourceHallDetail(index:Int) -> Void {
        var resource = ResourceDetailUIModel()
        let hall = self.followShipper.hall[index]
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
//        resource.carrierName = hall.consignorName
          resource.consignorName = hall.consignorName
        resource.resource = hall
        resource.attention = hall.shipperCode.count > 0;
        self.toResouceDetail(resource: resource)
    }
    
    override func callBackForRefresh(param: Any?) {
        super.callBackForRefresh(param: param)
        let info = param as! CarrierQueryOrderHallResult
        var newHalls = self.followShipper.hall
        self.followShipper.hall.enumerated().forEach { (offset, element) in
            if element.id == info.id {
                newHalls[offset] = info
            }
        }
        self.followShipper.hall = newHalls
        self.configResources()
    }
    
   
    
}
