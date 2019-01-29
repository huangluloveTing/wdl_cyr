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
    case getIndicatorMoney() //获取最低报价金额
    case updateSoftWare(UpdateSoftWareModel) //更新软件
    case forgetPassword(ForgetPasswordModel) //忘记密码
    case addDriverOwn(ZbnTransportCapacity) //添加司机自己
    case editOrModifyDriverOwn(ZbnTransportCapacity) //编辑司机(修改自己)
    case identiferIsAddOwnAsDriver() //验证是否已经添加自己为司机
    case getMessageNum() //消息个数
    case login(String , String)     // 登录接口
    case getAutoDealTimer(String)     // 查询货源自动成交时间
    case register(String , String , String , String, String) // 注册
    case registerSms(String)        // 获取验证码
    case loadTaskInfo()             // 获取省市区
    case getCreateHallDictionary()  // 获取数据字典
    case releaseSource(ReleaseDeliverySourceModel)       // 发布货源
    case getMainMessage(MessageQueryBean)   //消息中心主页(无分页)
    case ownOrderHall(GoodsSupplyQueryBean)     // 我的关注的货源接口
    case findAllOrderHall(GoodsSupplyQueryBean) // 获取货源大厅数据
    case findOrderByFollowShipper()         //查询我已经关注托运人线下的货源信息
    
    case addFollowLine(String,String,String,String) //添加关注线路
    case findOrderByFollowLine()            //查询我已经关注线路线下的货源信息
    case selectZbnConsignor(String)         //获取所有的未关注运人信息
    case addFollowShipper(AddShipperQueryModel) // 关注托运人
    case findTransportCapacity(QueryZbnTransportCapacity) // 获取所有的运力信息
    case findCarrierInfoFee(String)         // 报价时，获取承运人保证金、服务费等信息
    case addOffer(CarrierOfferCommitModel)  // 承运人报价
    case selectOwnOffer(OfferQueryModel)    // 查询承运人自己的报价
//    case getOtherOfferByOrderHallId(String) // 根据货源id 获取 其他人的报价
    
    case getOtherOfferByOrderHallId(OfferOrderHallResultApp) // 根据货源id 获取 其他人的报价
    
    case getOfferByOrderHallId(OrderHallOfferQueryModel) // 根据货源ID获取报价详情
    case ownTransportPage(QuerytTransportListBean) // 获取我的运单列表
    case carrierAllButtonAcceptTransportState(Int, TimeInterval?, String , String?)//承运人操作运单（拒绝，接受，取消运输，继续运输）
    case queryTransportDetail(String,String)       // 获取运单详情
    case designateWaybill(String , String , String)  // 指派运单
    case assembleWaybill(WaybillAssembleCommitModel) // 单车配载
    case updatePassword(ModifyPasswordModel)    // 修改密码
    case updatePhone(ModityPhoneModel)          // 修改手机号码
    case assemblePlanWaybill([WaybillAssembleCommitModel]) // 多车配载
    case createEvaluate(ZbnEvaluateVo)      // 提交评价
    case cancelFouceCarrier(CancerFouceCarrier)      //通过关注托运人的编码，取消关注
      case getFoucesLineOrderById(CancerFouceCarrier)      //关注的路线下的对应的货源订单
    case getFoucesOrderById(CancerFouceCarrier)      //关注的托运下的对应的货源订单
    case cancelFoucePath(String)       // 取消线路的关注
    case cancelOffer(String , String)                        // 取消报价
    case findCapacityByDriverNameOrPhone(String)            // 根据驾驶员姓名/电话查询驾驶员信息
    case findCarrierByDriverName(OtherPageGotCarOrDriver)            // 报价配载界面根据驾驶员姓名/电话查询驾驶员信息
    case findCarrierCarByNo(OtherPageGotCarOrDriver)                         //获取运力车辆
    case addDriverWithPhone(String)            // 我的运力添加驾驶员下一步后进行搜索的接口
    case findCapacityByName(String)                         //获取运力车辆
    case getCarrierInformation()                            // 获取登陆承运人信息
    case zbnBondInformation()                               // 获取承运人保证金数据
    case findCarInformation(String)                               // 获取我的车辆
    case findDriverInformation(String)                            // 获取我的司机
    case uploadImage(UIImage , UploadImagTypeMode)   // 上传图片
    case markHasSeenMessage(MessageQueryBean)                     // 标记查看过的消息
    case applyAcceptOrRefuseMessage(MessageQueryBean)                     // 接受或拒绝承运人的邀请
    
    case dealDetail(ZbnCashFlow)                     //交易明细
//    case returnMoney(String, String)   //退余额
    case returnMoney(ZbnCashFlow)   //退余额
    case rechargeMoney(ZbnCashFlow) //充值
    case deleteTransportCapacity(String) // 删除运力（车辆）
    case deleteDriver(String)            // 删除运力（司机）
    case addDriver(String)               // 添加司机
    case addCapacityInformation(ZbnTransportCapacity) // 添加车辆
    case dictionaryEntityByCode(BasicDictionaryKeyMode) // 获取数据字典接口
    case carrierIdentifer(ZbnCarrierInfo)//承运人认证
    case addOrderHallReturn(OrderHallReturnVo) // 申请签收
    case getCarrierHallDictionary()
    case updateReturnImg(String , String)   // 上传回单
    case positionCarrier(CarrierPositionVo) // 上传承运人的经纬度
    case findTransportByTransportStatus(QuerytTransportListBean) // 获取运输计划运单
//    case transportPlanAcceptRefuse(ZbnTransportVehicle) // 接受还是拒绝y承运
}


// PATH
func apiPath(api:API) -> String {
    switch api {
    case .getAutoDealTimer(_):
        return "/offer/queryHallSurplusTime"
    case .editOrModifyDriverOwn(_):
        return "/transportCapacity/updateDriverOfMy"
    case .addDriverOwn(_):
        return "/transportCapacity/addDriverOfMy"
    case .forgetPassword(_):
        return "/carrier/forgetPassWord"
    case .updateSoftWare(_):
        return "/app/common/getApkVersion"
    case .identiferIsAddOwnAsDriver():
        return "/transportCapacity/validateIsOrAddDriverOfMy"
    case .applyAcceptOrRefuseMessage(_):
        return "/message/handleCarrierInvite"
    case .getMessageNum():
        return "/message/messageNumber"
    case .getIndicatorMoney():
        return "/wallet/miniNumCash"
    case .rechargeMoney(_):
        return "/wallet/addCash"
    case .dealDetail(_):
        return "/wallet/cashFlotInformation"
    case .returnMoney(_):
        return "/wallet/refundCash"
    case .getMainMessage(_):
        return "/message/getMessage"
    case .updatePassword(_):
        return "/consignor/updatePassword"
    case .updatePhone(_):
        return "/consignor/updatePhone"
    case .cancelFoucePath(_):
        return "/followLine/cancelFollowLine"
    case .cancelFouceCarrier(_):
        return "/followShipper/cacleFollow"
    case .getFoucesOrderById(_):
        return "/followShipper/findOrderHallByFollowShipperId"
    case .getFoucesLineOrderById(_):
        return "/followLine/findOrderHallByFollowLineId"
    case .login(_, _):
        return "/carrier/login"
    case .register(_, _, _, _, _):
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
        return "/followLine/findOrderByFollowLineApp"
    case .addFollowLine(_, _, _, _):
        return "/followLine/addFollowLine"
    case .selectZbnConsignor(_):
        return "/followShipper/selectZbnConsignor"
    case .addFollowShipper(_):
        return "/followShipper/addFollowShipper"
    case .findTransportCapacity(_):
        return "/transportCapacity/findTransportCapacity"
    case .findCarrierInfoFee(_):
        return "/offer/findCarrierInfoFee"
    case .addOffer(_):
        return "/offer/addOffer"
    case .selectOwnOffer(_):
        return "/offer/selectOwnOfferApp"
//    case .getOfferByOrderHallId(_):
//        return "/orderHall/findOrderHallAndOffer"
        
    case .getOfferByOrderHallId(_):
        return "/carrierOrderHall/findPlanHallDetails"
        
    case .ownTransportPage(_):
        return "/carrierTransport/findCarrierTransportList"
    case .carrierAllButtonAcceptTransportState(_):
        return "/carrierTransport/carrierHandleTransport"
    case .queryTransportDetail(_,_):
        return "/carrierTransport/getTransportOrderDetail"
    case .designateWaybill(_, _ , _):
        return "/carrierTransport/assignmentWaybill"
    case .assembleWaybill(_):
        return "/carrierTransport/allocateVehicles"
    case .assemblePlanWaybill(_):
        return "/carrierTransport/allocateVehicleList"
    case .createEvaluate(_):
        return "/message/createEvaluate"
    case .getOtherOfferByOrderHallId(_):
        return "/offer/getOtherOfferByOrderHallId"
    case .cancelOffer(_ , _):
        return "/offer/cancelOffer"
    case .findCapacityByDriverNameOrPhone(_):
        return "/transportCapacity/findDriverInformation"
    case .findCarrierByDriverName(_):
        return "/transportCapacity/findTransportCapacity"
    case .addDriverWithPhone(_):
    
        return "/transportCapacity/findDriverByPhone"
        
    case .findCarrierCarByNo(_):
        return "/transportCapacity/findVehicleformation"
    case .findCapacityByName(_):
        return "/transportCapacity/findCarInformation"
    case .getCarrierInformation():
        return "/information/getCarrierInformation"
    case .zbnBondInformation():
        return "/wallet/zbnBondInformation"
    case .findCarInformation(_):
        return "/transportCapacity/findCarInformation"
    case .findDriverInformation(_):
        return "/transportCapacity/findDriverInformation"
    case .markHasSeenMessage(_):
        return "/message/markMessage"
    case .uploadImage(_ , let mode):
        return "/commom/upload/file/" + mode.rawValue
    case .deleteTransportCapacity(_):
        return "/transportCapacity/deleteTransportCapacity"
    case .deleteDriver(_):
        return "/transportCapacity/deleteDriver"
    case .addDriver(_):
        return "/transportCapacity/addDriver"
    case .addCapacityInformation(_):
        return "/transportCapacity/addCapacityInformation"
    case .dictionaryEntityByCode(_):
        return "/app/common/dictionaryEntityByCode"
    case .carrierIdentifer(_):
        return "/information/authentication"
    case .addOrderHallReturn(_):
        return "/carrierTransport/addOrderHallReturn"
    case .getCarrierHallDictionary():
        return "/app/common/getCarrierHallDictionary"
    case .updateReturnImg(_ , _):
        return "/carrierTransport/updateReturnImg"
    case .positionCarrier(_):
        return "/carrierTransport/positionCarrier"
    case .findTransportByTransportStatus(_):
        return "/carrierTransport/findTransportByTransportStatus"
    }
}

// TASK
func apiTask(api:API) -> Task {
    switch api {
    case .getMessageNum():
        return .requestPlain
    case .getIndicatorMoney():
        return .requestPlain
    case .identiferIsAddOwnAsDriver():
        return .requestPlain
    case .editOrModifyDriverOwn(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .addDriverOwn(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .forgetPassword(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .updateSoftWare(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .getAutoDealTimer(let hallId):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["hallId":hallId])
    case .returnMoney(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .dealDetail(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .rechargeMoney(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .markHasSeenMessage(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .applyAcceptOrRefuseMessage(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .getMainMessage(let model):
        return .requestParameters(parameters: model.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .registerSms(let phpne):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["cellphone":phpne])
        
    case .findCarrierInfoFee(let id):
        return .requestCompositeParameters(bodyParameters: [String:Any](), bodyEncoding: JSONEncoding.default, urlParameters: ["hallId": id])
    case .findTransportByTransportStatus(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        
    case .register(let pwd, let phone, let vcode, let vpwd,let adPhone):
        return .requestParameters(parameters: ["password": pwd,"phone": phone,"verificationCode": vcode,"verificationPassword": vpwd,"refereePhone": adPhone], encoding: JSONEncoding.default)
        
    case .updatePassword(let model):
        return .requestParameters(parameters: model.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        
    case .updatePhone(let model):
        return .requestParameters(parameters: model.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
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
        
    case .cancelFoucePath(let query):
        return .requestCompositeParameters(bodyParameters: [String:String](), bodyEncoding: JSONEncoding.default, urlParameters: ["lineCode":query])
        
    case .addFollowShipper(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .findTransportCapacity(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)

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
    case .queryTransportDetail(let hallId,let  transportNo):
        return .requestParameters(parameters: ["hallId":hallId, " transportNo":  transportNo], encoding: URLEncoding.default)
        
    case .designateWaybill(let phone, let transportNo , let hallId):
        return .requestParameters(parameters: [  "phone": phone,"transportId": transportNo , "hallId" : hallId], encoding: JSONEncoding.default)
        
    case .assembleWaybill(let model):
        return .requestParameters(parameters: model.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        
    case .assemblePlanWaybill(let models):
        let json = models.toJSONString() ?? ""
        let data = json.data(using: .utf8) ?? Data()
        return .requestData(data)
        
    case .createEvaluate(let evaluate):
        return .requestParameters(parameters: evaluate.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        
    case .cancelFouceCarrier(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
      
    case .getFoucesOrderById(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .getOtherOfferByOrderHallId(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
    case .getFoucesLineOrderById(let query):
        return .requestParameters(parameters: query.toJSON() ?? [String:String](), encoding: JSONEncoding.default)
//    case .getOtherOfferByOrderHallId(let hallId):
//        return .requestParameters(parameters: ["hallId": hallId], encoding: JSONEncoding.default)
    case .cancelOffer(let hallId , let offerId):
        return .requestParameters(parameters: ["hallId": hallId , "id":offerId], encoding: JSONEncoding.default)
    case .findCapacityByDriverNameOrPhone(let nameOrPhone):
        return .requestParameters(parameters: ["nameOrPhone" : nameOrPhone], encoding: URLEncoding.default)
    case .findCarrierByDriverName(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
        
    case .addDriverWithPhone(let phone):
      
        return .requestParameters(parameters: ["phone" : phone], encoding: URLEncoding.default)
    case .findCarrierCarByNo(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .findCapacityByName(let name):
        return .requestParameters(parameters: ["name" : name], encoding: URLEncoding.default)
    case .getCarrierInformation():
        return .requestParameters(parameters: Dictionary(), encoding: JSONEncoding.default)
    case .zbnBondInformation():
        return .requestParameters(parameters: Dictionary(), encoding: JSONEncoding.default)
    case .findCarInformation(let name):
        return .requestParameters(parameters: ["name":name], encoding: URLEncoding.default)
    case .findDriverInformation(let name):
        return .requestParameters(parameters: ["name":name], encoding: URLEncoding.default)
        
    case .uploadImage(let image , _):
        var imageData:Data? = UIImagePNGRepresentation(image)
        if imageData == nil {
            imageData = UIImageJPEGRepresentation(image, 1)
        }
        let formProvider = MultipartFormData.FormDataProvider.data(imageData!)
        let formData = MultipartFormData.init(provider: formProvider, name: "file", fileName: "img.png", mimeType: "image/png")
        return .uploadMultipart([formData])
        
    case .deleteTransportCapacity(let id) :
        return .requestParameters(parameters: ["id":id], encoding: URLEncoding.default)
    case .deleteDriver(let id):
        return .requestParameters(parameters: ["id":id], encoding: URLEncoding.default)
    case .addDriver(let phone):
        return .requestParameters(parameters: ["phone":phone], encoding: URLEncoding.default)
    case .addCapacityInformation(let capacity):
        return .requestParameters(parameters: capacity.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .dictionaryEntityByCode(let code):
        return .requestParameters(parameters: ["dataDictionaryTypeCode" : code.rawValue], encoding: URLEncoding.default)
    case .carrierIdentifer(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .addOrderHallReturn(let query):
        return .requestParameters(parameters: query.toJSON() ?? Dictionary(), encoding: JSONEncoding.default)
    case .getCarrierHallDictionary():
        return .requestPlain
    case .updateReturnImg(let imgUrl , let transportNo):
        return .requestParameters(parameters: ["returnBillUrl":imgUrl , "transportNo" : transportNo] , encoding: JSONEncoding.default)
    case .positionCarrier(let vo):
        return .requestParameters(parameters: vo.toJSON() ?? Dictionary() , encoding: JSONEncoding.default)
    }
  
}

// METHOD
func apiMethod(api:API) -> Moya.Method {
    switch api {
    case .getCreateHallDictionary(),
         .getAutoDealTimer(_),
         .identiferIsAddOwnAsDriver(),
         .registerSms(_) ,
         .getMessageNum(),
         .selectZbnConsignor(_),
         .findCarrierInfoFee(_),
         .cancelFoucePath(_),
         .queryTransportDetail(_),
         .addDriverWithPhone(_),
         .findCapacityByName(_),
         .findCapacityByDriverNameOrPhone(_),
         .findCarInformation(_),
         .deleteTransportCapacity(_),
         .deleteDriver(_),
         .addDriver(_),
         .findDriverInformation(_),
         .dictionaryEntityByCode(_),
         .getCarrierHallDictionary():
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


