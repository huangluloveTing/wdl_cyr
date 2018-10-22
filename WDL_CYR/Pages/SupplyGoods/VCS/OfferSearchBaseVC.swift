//
//  OfferSearchBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/22.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum OfferSearchStyle {
    case driverSearch       // 搜索司机
    case truckSearch        // 搜索车辆
}

class OfferSearchBaseVC: NormalBaseVC {
    
    private var baseTableView:UITableView!
    private var currentList:[OfferSearchUIModel] = []
    
    public var currentStyle:OfferSearchStyle? = .driverSearch

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // override
    
}

// public
extension OfferSearchBaseVC {
    // 设置数据
    func toRefreshTableView(lists:[OfferSearchUIModel]) -> Void {
        self.currentList = lists
        self.baseTableView.reloadData()
    }
    
    // 刷新某一项
    func toRefresh(index:Int , item:OfferSearchUIModel) -> Void {
        self.currentList[index] = item
        self.baseTableView.reloadData()
    }
}


// config
extension OfferSearchBaseVC {
    func configTableView() -> Void {
        self.baseTableView.delegate = self
        self.baseTableView.dataSource = self
        self.baseTableView.registerCell(nib: ChooseDriverCell.self)
        self.baseTableView.registerCell(nib: OfferSearchTruckCell.self)
    }
    
    func defineTableView(tableView:UITableView) -> Void {
        self.baseTableView = tableView
        self.configTableView()
    }
}

extension OfferSearchBaseVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.currentList[indexPath.section]
        if self.currentStyle == .driverSearch {
            let cell = tableView.dequeueReusableCell(nib: OfferSearchTruckCell.self)
            cell.showInfo(vichelNo: item.vichelNo, type: item.type, length: item.length, weight: item.weight, check: item.check)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(nib: ChooseDriverCell.self)
        cell.showInfo(driverName: item.driverName, idNo: item.idCard, phone: item.phone, checked: item.check)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension OfferSearchBaseVC {
    
    // 搜索
    func search(text:String) -> Observable<BaseResponseModel<[ZbnTransportCapacity]>> {
        var query = QueryZbnTransportCapacity()
        if self.currentStyle == .driverSearch {
            query.driverName = text
            query.driverPhone = text
        } else {
            query.vehicleNo = text
        }
        return BaseApi.request(target: API.findTransportCapacity(query), type: BaseResponseModel<[ZbnTransportCapacity]>.self)
            .asObservable()
    }
    
}


struct OfferSearchUIModel {
    var driverName:String = ""  // 驾驶员
    var idCard:String = ""      // 身份证号码
    var phone:String = ""       // 电话号码
    var vichelNo:String = ""    // 车牌号码
    var type:String = ""        // 车型
    var length:String = ""      // 车长
    var weight:String = ""      // 载重
    var check:Bool = false
}
