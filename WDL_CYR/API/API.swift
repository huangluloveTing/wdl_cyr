//
//  api.swift
//  SCM
//
//  Created by 黄露 on 2018/7/20.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import Moya

import Alamofire

enum API {
    case login(String , String)     // 登录接口
    case register(String , String , String , String) // 注册
    case registerSms(String)        // 获取验证码
    case loadTaskInfo()             // 获取省市区
    case getCreateHallDictionary()  // 获取数据字典
    case releaseSource(ReleaseDeliverySourceModel)       // 发布货源
    case ownOrderHall(GoodsSupplyQueryBean)     // 我的关注的货源接口
    case findAllOrderHall(GoodsSupplyQueryBean) // 获取货源大厅数据
    case findOrderByFollowShipper()         //查询我已经关注线路线下的货源信息
    case addFollowLine(String,String,String,String) //添加关注线路
    case findOrderByFollowLine()            //
    case selectZbnConsignor(String)         //获取所有的未关注运人信息
    case addFollowShipper(AddShipperQueryModel) // 关注托运人
    case findTransportCapacity(QueryZbnTransportCapacity) // 获取所有的运力信息
    case findCarrierInfoFee(String)         // 报价时，获取承运人保证金、服务费等信息
    case addOffer(CarrierOfferCommitModel)  // 承运人报价
    case selectOwnOffer(OfferQueryModel)    // 查询承运人自己的报价
    case getOfferByOrderHallId(OrderHallOfferQueryModel) // 根据货源ID获取报价详情
    case ownTransportPage(QuerytTransportListBean) // 获取我的运单列表
    case carrierAllButtonAcceptTransportState(Int, TimeInterval?, String , String?)//承运人操作运单（拒绝，接受，取消运输，继续运输）
  
    
}


// PATH
func apiPath(api:API) -> String {
    switch api {
    case .login(_, _):
        return "/carrier/login"
    case .register(_, _, _, _):
        return "/carrier/carrierRegister"
    case .registerSms(_):
        return "/carrier/carrierRegisterSms"
    case .loadTaskInfo():
        return "/app/common/getAllCityAreaList"
    case .getCreateHallDictionary():
        return "/app/common/getCreateHallDictionary"
    case .releaseSource(_):
        return "/orderHall/releaseSource"
    case .ownOrderHall(_):
        return "/orderHall/ownOrderHall"
    case .findAllOrderHall(_):
        return "/carrierOrderHall/findAllOrderHall"
    case .findOrderByFollowShipper():
        return "/followShipper/findOrderByFollowShipper"
    case .findOrderByFollowLine():
        return "/followLine/findOrderByFollowLine"
    case .addFollowLine(_, _, _, _):
        return "/followLine/addFollowLine"
    case .selectZbnConsignor(_):
        return "/followShipper/selectZbnConsignor"
    case .addFollowShipper(_):
        return "/followShipper/addFollowShipper"
    case .findTransportCapacity(_):
        return "/carrierOrderHall/findTransportCapacity"
    case .findCarrierInfoFee(_):
        return "/offer/findCarrierInfoFee"
    case .addOffer(_):
        return "/offer/addOffer"
    case .selectOwnOffer(_):
        return "/offer/selectOwnOfferApp"
    case .getOfferByOrderHallId(_):
        return "/orderHall/findOrderHallAndOffer"
    case .ownTransportPage(_):
        return "/carrierTransport/findCarrierTransportList"
    case .carrierAllButtonAcceptTransportState(_):
        return "/carrierTransport/carrierHandleTransport"
    }
}

// TASK
func apiTask(api:API) -> Task {
    switch api {
    case .registerSms(let phpne):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["cellphone":phpne])
    case .register(let pwd, let phone, let vcode, let vpwd):
        return .requestParameters(parameters: ["password": pwd,"phone": phone,"verificationCode": vcode,"verificationPassword": vpwd], encoding: JSONEncoding.default)
    case .login(let account , let pwd):
        return .requestParameters(parameters: ["cellphone":account,"password":pwd], encoding: JSONEncoding.default)
    case .loadTaskInfo():
        return .requestPlain
    case .getCreateHallDictionary():
        return .requestPlain
    case .releaseSource(let resource):
        return .requestParameters(parameters: resource.toJSON()!, encoding: JSONEncoding.default)
    case .ownOrderHall(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .findAllOrderHall(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String : String](), encoding: JSONEncoding.default)
    case .findOrderByFollowShipper():
        return .requestParameters(parameters: [String : String](), encoding: JSONEncoding.default)
    case .findOrderByFollowLine():
        return .requestParameters(parameters: [String : String](), encoding: JSONEncoding.default)
    case .addFollowLine(let startProvince, let startCity, let endProvince, let endCity):
        return .requestParameters(parameters: ["startPointProvince":startProvince , "startPointCity":startCity , "endPointProvince":endProvince,"endPointCity":endCity], encoding: JSONEncoding.default)
    case .selectZbnConsignor(let query):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["queryParams":query])
    case .addFollowShipper(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .findTransportCapacity(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .findCarrierInfoFee(let id):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["hallId": id])
    case .addOffer(let commit):
        return .requestParameters(parameters: commit.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .selectOwnOffer(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .getOfferByOrderHallId(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .ownTransportPage(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        /*
         handleType (integer): 操作类型（3=拒绝，4=接受，8=取消运输，7=继续运输） ,
         loadingTime (string, optional): （继续运输时）装货时间 ,
         transportNo (string): 运单号
         hallId :string 货源id ,(只有在操作 - 继续运输 提交时间才将hallid传入)
         */
    case .carrierAllButtonAcceptTransportState(let handleType , let loadingTime, let transportNo,let hallId):
        var params = ["handleType":handleType, "transportNo":transportNo] as [String : Any]
        if let loadTime = loadingTime {
            params["loadingTime"] = loadTime
        }
        if let hallId = hallId {
            params["hallId"] = hallId
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}

// METHOD
func apiMethod(api:API) -> Moya.Method {
    switch api {
    case .getCreateHallDictionary(),
         .registerSms(_) ,
         .selectZbnConsignor(_),
         .findCarrierInfoFee(_):
        return .get
    default:
        return .post
    }
}

// 分页
private func getPageParams( start:Int = 0, limit:Int = 10) -> [String : Any] {
    return ["start":start , "limit":limit]
}

extension API :TargetType {
    
    var baseURL: URL {
        return URL.init(string: HOST)!
    }
    
    var path: String {
        return apiPath(api: self)
    }
        
    
    var method:Moya.Method {
        return apiMethod(api: self)
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return apiTask(api: self)
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"];
    }
    
}


