//
//  SearchConsignorModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation
import HandyJSON

// 搜索未关注托运人的model
struct ConsignorFollowShipper : HandyJSON {
    var consignorCode:String? // (string, optional),
    var consignorName:String? // (string, optional),
    var consignorType:String? // (string, optional),
    var logParh:String?         // (string, optional),
    var orderNumer:String? // (string, optional)
    var focus:Bool = false
}

//关注托运人的query模型
struct AddShipperQueryModel : HandyJSON {
    var shipperId : String = "" // (string): 托运人ID ,
    var shipperType : String = "" // (string): 托运人类型
}

// 搜索 车辆 或者 承运人的 请求参数 模型
struct QueryZbnTransportCapacity : HandyJSON {
    var driverName : String? // (string): 司机姓名 ,
    var driverPhone : String? // (string): 司机联系方式 ,
    var vehicleNo : String? // (string): 车牌号 ,
}


// 搜索 车辆 和 承运人的返回数据 模型
struct OtherPageGotCarOrDriver : HandyJSON {
    var driverName : String = "" // (string): 司机姓名 ,
     var vehicleNo : String = "" // (string): 车牌号 ,
}

// 搜索 车辆 和 承运人的返回数据 模型
struct ZbnTransportCapacity : HandyJSON {
  
    var address : String = "" // (string): 地址 ,
    var belongToCarrier : String = "" // (string): 所属承运人 ,
    var capacityType : Int = 1 // (integer): 运力类型 1=司机 2=承运人 ,
    var createTime : TimeInterval = 0 // (string): 创建时间 ,
    var dealCount : Int = 0 // (integer): 历史成交笔数 ,
    var driverId : String = "" // (string): 身份证 ,
    var gender : String = "1" //"1" 男 "0" 女
    var driverName : String = "" // (string): 司机姓名 ,
    var birdthDay : TimeInterval = 0  // (string): 生日 ,
    var quasiDrivingModel : String = ""// (string): 准驾车型 ,
    var driverArchivesNo : String = ""//  (string): 档案编号 ,
    var driverFileNo : String = ""//  (string): 驾驶证编号 ,
    var driverPhone : String = "" // (string): 司机联系方式 ,
    var drivingLicensePhoto : String = "" // (string): 行驶证照片 ,
    var endTime : TimeInterval = 0 // (string): 结束时间 ,
    var engineNumber : String = "" // (string): 发动机号码 ,
    var id : String = "" // (string),
    var nationality : String = "" //  (string): 国籍 ,
    var initialLicenseDate : TimeInterval = 0  // (string): 初次领证日期 ,
    var inspectionValidityDate : TimeInterval = 0  //(string): 检验有效期 ,
    var insuranceExpirationDate : TimeInterval = 0 // (string): 保险到期时间 ,
    var driverLecenseEndDate : TimeInterval = 0 //  (string): 驾驶证有效期止 ,
    var driverLecenseStartDate : TimeInterval = 0 //  (string): 驾驶证有效期开始 ,
    var insurancePhoto : String = "" // (string): 保险单照 ,
    var overallScore : Float = 0 // (number): 综合评分 ,
    var registrationDate : TimeInterval = 0 // (string): 注册日期 ,
    var startTime : TimeInterval = 0 // (string): 开始时间 ,
    var status : Int = 1 // (integer): 审核状态 ,
    var transportStatus : Int = 0 // (integer): 运输状态 0=空闲 1=已配载 2=运输中 ,
    var useProperty : String = "" // (string): 使用性质 ,
    var vehicleIdCode : String = "" // (string): 车辆识别代码 ,
    var vehicleLength : String = "" // (string): 车长 ,
    var vehicleNo : String = "" // (string): 车牌号 ,
    var vehiclePhoto : String = "" // (string): 货车照片 ,
    var vehicleType :String = "" // (string): 车辆类型 ,
    var vehicleVolume : String = "" // (string): 体积 ,
    var vehicleWeight : String = "" // (string): 载重 ,
    var vehicleWidth : String = "" // (string): 车宽
}

//报价时，获取承运人保证金、服务费等信息
struct CarrierInfoFee : HandyJSON {
    // 单车保证金
    var bondSingleVehicle : Float = 0
    // 承运人
    var carrierName : String = ""
    // 电话
    var cellPhone : String = ""
    // 企业简称
    var companyAbbreviation : String = ""
    // 公司名称
    var companyName : String = ""
    // 冻结金额
    var frozenMoney : Float = 0
    // 单次服务费价格
    var singleTimeFee : Float = 0
    // 总金额
    var totalMoney : Float = 0
    // 可支配金额
    var useableMoney : Float = 0
}


