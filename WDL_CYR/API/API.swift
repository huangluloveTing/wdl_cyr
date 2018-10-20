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
    case findOrderByFollowShipper() //查询我已经关注线路线下的货源信息
    case addFollowLine(String,String,String,String) //添加关注线路
    case findOrderByFollowLine()  //
    case selectZbnConsignor(String) //获取所有的未关注运人信息
    case addFollowShipper(AddShipperQueryModel) // 关注托运人
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
    }
}

// METHOD
func apiMethod(api:API) -> Moya.Method {
    switch api {
    case .getCreateHallDictionary(),
         .registerSms(_) ,
         .selectZbnConsignor(_):
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


