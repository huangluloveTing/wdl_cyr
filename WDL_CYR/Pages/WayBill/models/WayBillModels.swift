//
//  WayBillModels.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

enum WaybillProcessStatus : Int {
    case carrierDesignateMe_unassembleAndUnRecieved = 0 // 其他承运人指派给我的，未装配未接受
    case shipperDesignateMe_unassembleAndUnRecieved     // 托运人指派给我，未装配未接受
    case carrierRecieveNotStart_unassembleAndUnRecieved // 承运人接受但还未生成运单，未装配未接受
    case designate_unassembleAndUnRecieved              // 承运人指派运单，未装配未接受
    case carrierDesignateMe_unassemble                  // 其他承运人指派给我的，未装配已接受
    case shipperDesignateMe_unassemble                  // 托运人指派给我，未装配已接受
    case carrierRecieveNotStart_unassemble              // 承运人接受但还未生成运单，未装配已接受
    case designate_unassemble                           // 承运人指派运单，未装配已接受
    
}
