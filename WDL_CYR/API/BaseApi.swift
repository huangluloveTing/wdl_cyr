//
//  business.swift
//  SCM
//
//  Created by 黄露 on 2018/7/20.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import HandyJSON


struct BaseApi {
    
    private static let provider = MoyaProvider<API>(endpointClosure: myEndPoint ,requestClosure:requestClosure,plugins: [MyPlugins()])
    
    static func request<T: BaseResponse>(target:API, type:T.Type) -> Observable<T> {
        let observable = provider.rx.request(target)
            .asObservable()
            .mapModel(T.self)
        return observable
    }
}

func myEndPoint(target:TargetType) -> Endpoint {
    let endPoint = Endpoint(url: target.baseURL.absoluteString + target.path,
                            sampleResponseClosure: { () -> EndpointSampleResponse in
                                return .networkResponse(200, target.sampleData)
                            },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
    return endPoint
}

func requestClosure(endPoint:Endpoint , done:MoyaProvider<API>.RequestResultClosure ) -> Void {
    do {
     var request = try endPoint.urlRequest()
        request.timeoutInterval = 20.0
        request.addValue(WDLCoreManager.shared().userInfo?.token ?? "", forHTTPHeaderField:"Token" )
        request.addValue("", forHTTPHeaderField: "consignorToken")
        #if DEBUG
        print("parameters : \(String(describing: String(data: request.httpBody ?? Data(), encoding: .utf8)))")
        print("headers : \(request.allHTTPHeaderFields ?? Dictionary())")
        print("urL: \(request.url?.absoluteString ?? "")")
        print("method : \(request.httpMethod ?? "")")
        #endif
        done(.success(request))
    }
    catch let error {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

struct MyPlugins: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("headers: ",request.allHTTPHeaderFields ?? Dictionary())
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
    }
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}
