//
//  PersonModels.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/10/15.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation
import HandyJSON

enum ConsignorType:Int , HandyJSONEnum {
    case agency  = 1
    case third = 2
}

 //状态(0:未审核，1：审核中，2：审核失败（驳回），3：审核通过) ,
enum AutherizStatus:Int , HandyJSONEnum {
    case not_start = 0
    case autherizing = 1
    case autherizedFail = 2
    case autherized = 3
}

struct ZbnConsignor : HandyJSON {
    var authenticationMsg:String? //认证信息 ,
    var businessLicense:String? // 营业执照
    var businessLicenseNo:String? //营业执照号
    var cellPhone:String? // h手机号码
    var companyAbbreviation:String? //企业简称
    var companyLogo:String?     //企业logo
    var companyName:String?     //企业名称 
    var consignorName:String?   // 联系人
    var consignorNo:String?     // 托运人ID
    var consignorType:ConsignorType? //属性 1=经销商 2=第三方 ,
    var createTime:TimeInterval = 0
    var endTime:TimeInterval = 0
    var id:String = ""
    var legalPerson:String? // 法人姓名 
    var legalPersonId:String?   //法人身份证号
    var legalPersonIdFrontage:String?   // 法人身份证正面照
    var legalPersonIdOpposite:String?   //法人身份证反面照
    var officeAddress:String? // (string): 办公地址 ,
    var passWord :String? // (string): 密码 ,
    var remark : String? // (string): 备注 ,
    var score : Float = 0 // (number): 平分 ,
    var startTime : TimeInterval = 0 // (string): 开始时间 ,
    var status : AutherizStatus = .not_start // (integer): 状态(0:未审核，1：审核中，2：审核失败（驳回），3：审核通过) ,
    var transactionCount : Int = 0 // (integer): 成交数量
    var token:String?
}



//忘记密码
struct ForgetPasswordModel : HandyJSON {

    var phone:String = ""  //   电话号码 ,
    var verificationCode:String = "" // (string): 验证码 ,
    var password:String = "" //(string): 密码 ,
    var verificationPassword:String = "" // (string): 确认密码
   
}

//软件更新
struct UpdateSoftWareModel : HandyJSON {
    
    var content:String = ""
    var downloadUrl:String = ""
    var must:Int = 2 //(integer): 是否强制更新 1=是 2=否 ,
    var softwareType:Int = 2 // (integer): 软件类型：1=托运人 2=承运人 ,
    var terminalType:Int = 1 // (integer): 终端类型：1=ios 2=Android ,
    var versionCode:Int = 1
}

//消息中心
struct MessageQueryBean: HandyJSON{
    var id: String? //消息id
    var msgTo: String?      //消息接收人（当前用户的id号）
    var startTime: String?  //开始时间
    var endTime: String?    //结束时间
    var msgType: Int?       // 消息类型 1=系统消息 2=报价消息 3=运单消息 ,
    var pageNum: Int  = 0       //当前页数
    var createTime: TimeInterval?  //发送时间
    var hallNo: String?     //货源号(货源id/运单id)
    var msgFrom: String?    //消息发送人
    var msgInfo: String?    //消息体
    var transportNo: String? //运单号
    var msgStatus: Int = 0     //消息状态： 0=未读 1=已读 2=接受 3=拒绝
    var pageSize: Int?      //页面大小
}


struct PageInfo<T:HandyJSON> : HandyJSON {
    var list : [T]? // (Array[ZbnMessage], optional),
    var pageNum : Int? // (integer, optional),
    var pageSize : Int? // (integer, optional),
    var total : Int? // (integer, optional)
}


struct AuthConsignorVo : HandyJSON {
    var businessLicense : String? // (string): 营业执照 ,
    var businessLicenseNo:String? // (string): 营业执照号 ,
    var companyAbbreviation : String? // (string): 企业简称 ,
    var companyLogo : String? // (string): 企业logo ,
    var companyName : String? // (string): 企业名称 ,
    var consignorName : String? // (string): 联系人 ,
    var legalPerson :String? // (string): 法人姓名 ,
    var legalPersonId : String? // (string): 法人身份证号 ,
    var legalPersonIdFrontage : String? // (string): 身份证正面照 ,
    var legalPersonIdOpposite : String? // (string): 身份证反面照 ,
    var officeAddress : String? // (string): 办公地址
}


//充值
struct ZbnCashFlow : HandyJSON {
    
    var money: String?//添加的用于退款的金额存储
    
    var balance : Float? // (number): 余额 ,
    var carrierName : String?//  (string): 承运人 ,
    var carrierNo : String? // (string): 承运人ID ,
    var cellPhone : String? // (string): 联系电话 ,
    var createTime : TimeInterval?  //(string): 创建时间 ,
    var endTime : TimeInterval? // (string): 结束时间 ,
    var flowMoney : Float? // (number): 金额 ,
    var flowNo : String? // (string): 流水号 ,
    var flowStatus : Int?  //(integer):0=支付失败 1=支付成功  2 - 支付中  3-取消充值
    var flowType : Int?  // (integer):类型 1=充值 2=退钱 3=信息费扣除 4=信息费退回 5=违约金扣除 6=违约金退回 7=保证金扣除 8=保证金退回 9=保证金释放 10=平台充值
    var frozenMoney : Float?  // (number): 冻结余额 ,
    var id : String?
    var ids : [String]?   //ids (Array[string], optional),
    var pageNum : Int = 0   // (integer): 当前页数 ,
    var pageSize : Int = 20   // (integer): 页面大小 ,
    var payType : Int?   // (integer, optional): 0=支付失败 1=支付成功 ,
    var remark : String?   // (string),
    var startTime : TimeInterval?    //(string): 开始时间 ,
    var transportNo : String?   //(string): 运单号
}

struct CarrierPositionVo : HandyJSON {
    var carrierId : String? // (string): 承运人ID ,
    var latitude : Float? // (number): 经度 ,
    var longitude : Float? // (number): 经度
}


struct ZbnTransportVehicle : HandyJSON {
    var carrierId : String? // (string): 承运人ID ,
    var carrierName : String? // (string): 承运人姓名 ,
    var createTime : String? // (string),
    var driverId : String? // (string): 司机ID ,
    var driverName : String? // (string): 司机姓名 ,
    var driverPhone : String? // (string, optional),
    var endTime : String? // (string): 结束时间 ,
    var id : String? // (string),
    var isAccepted : String? // (string): 接受还是拒绝 ,
    var loadWeight : Float? // (number): 载重 ,
    var oldVehicleNo : String? // (string): 之前车牌号 ,
    var opType : String? // (string, optional),
    var ordNo : String? //  (string): 订单号 ,
    var transportNo : String? // (string): 运单ID ,
    var vehicleNo : String? // (string): 车牌号
}
