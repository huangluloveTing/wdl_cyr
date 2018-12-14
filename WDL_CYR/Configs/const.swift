//
//  const.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/23.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

let KF_PHONE_NUM = "03106591999"  // 客服电话
let BUTTON_FONT = UIFont.systemFont(ofSize: 16)
let IPHONE_WIDTH = UIScreen.main.bounds.size.width
let IPHONE_HEIGHT = UIScreen.main.bounds.size.height
let IPHONE_RATE = (IPHONE_WIDTH / 375.0) > 1 ? 1 : (IPHONE_WIDTH / 375.0)

//let DEBUG_ACCOUNT = "18100000000"
//let DEBUG_PASSWORD = "q123456"

let DEBUG_ACCOUNT = ""
let DEBUG_PASSWORD = ""


#if DEBUG

//外网测试
let HOST = "http://182.150.21.104:58092/zbn-web"

//本地测试
//liaobing

//let HOST = "http://172.16.58.15:8081/zbn-web"
//zhaoxiaoyang
//let HOST = "http://172.16.8.52:8081/zbn-web"

let GAODE_MAP_KEY = "8e99eeada50ef322b5c993eb92acffd6"


//极光推送的key
let JPushAppKey = "db2771dd3e1276628b07fe23"
let JPushMasterSecret = "2a32fcb079991db342500952"

#else

let HOST = "http://182.150.21.104:58092/zbn-web"
let GAODE_MAP_KEY = "8e99eeada50ef322b5c993eb92acffd6"

//极光推送的key
let JPushAppKey = "db2771dd3e1276628b07fe23"
let JPushMasterSecret = "2a32fcb079991db342500952"

#endif

//MARK: - 通知中心
let PUSH_MESSAGE_VALUE = "PUSH_MESSAGE_VALUE"  // 消息推送通知


