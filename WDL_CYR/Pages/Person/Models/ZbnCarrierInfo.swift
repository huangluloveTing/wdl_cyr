//
//  ZbnCarrierInfo.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/30.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import HandyJSON

struct ModifyPasswordModel : HandyJSON {
    //    carrierCode (string): 承运人/托运人编码，后台自动获取 ,
    //    oldPassword (string): 旧密码 ,
    //    password (string): 密码 ,
    //    verificationPassword (string): 确认密码
    var carrierCode:String = ""
    var oldPassword:String = ""
    var password:String = ""
    var verificationPassword:String = ""
}

struct ModityPhoneModel : HandyJSON {
    //    carrierCode (string): 承运人/托运人编码，后台自动获取 ,
    //    oldPassword (string): 旧密码 ,
    //    password (string): 密码 ,
    //    phone (string): 电话号码 ,
    //    verificationCode (string): 验证码 ,
    //    verificationPassword (string): 确认密码
    var carrierCode:String = ""
    var phone:String = ""
    var verificationCode : String = ""
}


enum CarrierAuthMode : Int, HandyJSONEnum { // 承运人认证状态
    case authed = 3    // 已认证
    case unAuth = 0    // 未认证
    case authing = 1    // 认证中
    case authFail = 2    // 驳回，认证失败
   
}

struct ZbnCarrierInfo: HandyJSON {
    
    var authenticationMsg: String?//认证错误信息
    var activityRate : String? // (string): 活跃度 ,
    var addedCount : Int = 0 // (integer): 承运人被添加次数 ,
    var address : String? // (string): 地址 ,
    var bidPriceCount : Int = 0 // (integer): 竞价次数 ,
    var breachCount : Int = 0 // (integer): 违约次数 ,
    var breachRate : String? // (string): 违约率 ,
    var businessLicense : String? // (string): 营业执照 ,
    var businessLicenseNo : String? // (string): 营业执照号 ,
    var carrierAccount : String? // (string): 承运人账号 ,
    var carrierName : String? // (string): 姓名 ,
    var carrierNo : String? // (string): 编号 ,
    var carrierType : Int = 1 // (integer): 属性 1=个人 2=企业 ,
    var cellPhone : String? // (string): 手机号 ,
    var companyAbbreviation : String? // (string): 企业简称 ,
    var companyName : String? //(string): 企业名称 ,
    var createTime : TimeInterval? // (string): 注册时间 ,
    var dealCount : Int? // (integer): 历史成交笔数 ,
    var dealRate : String? // (string): 成交率 ,
    var driverAudited : Int = 0 // (integer): 驾驶员运力已审核个数 ,
    var driverUnaudited : Int = 0 // (integer): 驾驶员运力未审核个数 ,
    var endTime : TimeInterval? // (string): 结束时间 ,
    var growupScore : Float = 0 // (number): 成长分=得分 ,
    var headPortrait : String? // (string): 头像URl ,
    var id : String? // (string),
    var idCard : String? // (string): 身份证 ,
    var idCardFrontage : String? // (string): 身份证正面照 ,
    var idCardHandheld : String? // (string): 手持身份证照 ,
    var idCardOpposite : String? // (string): 身份证背面照 ,
    var isAuth : CarrierAuthMode = .unAuth // (integer): 是否认证 0=未认证 1=认证 ,2=驳回 3=通过 4=冻结,
    var jpushAlias : String? // (string): 极光推送alias ,
    var jpushTag : String? // (string): 极光推送tag ,
    var lastTransportTime : TimeInterval? // (string): 最后一次承运时间 ,
    var legalPerson : String? // (string): 法人姓名 ,
    var legalPersonPhone : String? // (string): 法人联系电话 ,
    var overallScore : Float = 0 // (number): 综合评分 ,
    var passWord : String? // (string): 密码 ,
    var platformOrderAllNums : Int = 0 // (integer): 平台订单总数 ,
    var remark : String? // (string),
    var startTime : TimeInterval? // (string): 开始时间 ,
    var transportCount : Int = 0 // (integer): 承运次数 ,
    var vehicleAudited : Int = 0 // (integer): 车辆运力已审核个数 ,
    var vehicleUnaudited : Int = 0 // (integer): 车辆运力未审核个数,
    var token:String? //
}


struct ZbnBondInfo : HandyJSON { // 账号数据
    var bankAccount : String? // (string): 银行户名 ,
    var bankCard : String? // (string): 绑定银行卡 ,
    var bankName : String? // (string): 开户行 ,
    var carrierId : String? // (string): 承运人ID ,
    var endTime : TimeInterval = 0 // (string): 结束时间 ,
    var frozenMoney : Float = 0// (number): 冻结金额 ,
    var id : String? // (string): id ,
    var payAccount : String? // (string): 支付账号 ,
    var payPsword : String? // (string): 支付密码 ,
    var startTime : TimeInterval = 0 // (string): 开始时间 ,
    var totalMoney : Float = 0 //(number): 总金额 ,
    var useableMoney : Float = 0 // (number): 可支配金额
}
