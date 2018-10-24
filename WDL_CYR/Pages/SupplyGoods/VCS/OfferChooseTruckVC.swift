//
//  OfferChooseTruckVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/22.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OfferChooseTruckVC: OfferSearchBaseVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var lists:[ZbnTransportCapacity] = []
    
    public var searchResultClosure:OfferSearchResultClosure<ZbnTransportCapacity>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentStyle = .driverSearch
        self.defineTableView(tableView: self.tableView)
    }
    
    override func bindViewModel() {
        self.searchBar.rx.text.orEmpty.asObservable()
            .skip(1)
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (text) in
                self?.loadSearch(search: text)
            })
            .disposed(by: dispose)
    }
    
    override func zt_rightBarButtonAction(_ sender: UIBarButtonItem!) {
        if let closure = self.searchResultClosure {
            if self.currentCheckedIndex < self.lists.count {
                let capacity = self.lists[self.currentCheckedIndex]
                closure(capacity)
            }
        }
        self.pop()
    }
}

// 获取 搜索内容
extension OfferChooseTruckVC {
    
    func loadSearch(search:String) -> Void {
        self.search(text: search)
            .share(replay: 1)
            .asDriver(onErrorJustReturn: BaseResponseModel<[ZbnTransportCapacity]>())
            .asObservable()
            .subscribe(onNext: { [weak self](data) in
                self?.lists = data.data ?? []
                self?.configNetDataToUI()
            })
            .disposed(by: dispose)
    }
    
}


// 处理结果
extension OfferChooseTruckVC {
    
    func configNetDataToUI() -> Void {
        let uiModels = self.lists.map { (capacity) -> OfferSearchUIModel in
            var model = OfferSearchUIModel()
            model.driverName = capacity.driverName
            model.idCard = capacity.driverId
            model.phone = capacity.driverPhone
            model.type = capacity.vehicleType
            model.length = capacity.vehicleLength
            model.weight = capacity.vehicleWeight
            model.vichelNo = capacity.vehicleNo
            return model
        }
        self.toRefreshTableView(lists: uiModels)
    }
}
