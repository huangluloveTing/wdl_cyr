//
//  BaseReponse.swift
//  SCM
//
//  Created by 黄露 on 2018/7/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import HandyJSON

enum UploadImagTypeMode:String {
    case license_path = "upload_licence"
    case card_path = "upload_idCard"
    case logo_path = "upload_companyLogo"
    case bussiness_path = ""
    case returnbill_path = "upload_transport_return_filePath"
}


public protocol BaseResponse: HandyJSON {
    
    associatedtype Element

    var code:Int?{ get set }
    var message:String?{ get set }
    var data:Element? { get set }
}

struct BaseResponseModel<T:Any> : BaseResponse {
    typealias Element = T
    
    var data: T?
    
    var code: Int?
    
    var message: String?
}

struct BasePageModel<T:Any> : HandyJSON {
    var list : [T]?
    var pageNum : Int = 0
    var pageSize : Int = 0
    var total : Int = 0
}

public enum CustomerError : Error{
    case paramError(String?)
    case businessError(String?)
    case netError(String?)
    case httpFailed(String? , Int)
    case serialDataError(String?)
    case globalError(String? , Int)
}


extension CustomerError:LocalizedError {
    public var errorDescription:String? {
        switch self {
        case .paramError(let message):
            return message
        case .businessError(let message):
            return message
        case .netError(let message):
            return message
        case .httpFailed(let message, _):
            return message
        case .serialDataError(let message):
            return message
        case .globalError(let message, _):
            return message
        }
    }
}


