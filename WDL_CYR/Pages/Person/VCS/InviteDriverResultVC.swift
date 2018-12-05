//
//  InviteDriverResultVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class InviteDriverResultVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var driverPhone:String? // 司机的电话号码
    
    private var isLoaded:Bool = false
    
    private var currentTransCapacities:[ZbnTransportCapacity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        searchDrivers()
    }
}

extension InviteDriverResultVC {
    //MARK: -
    func configTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nib: InviteDriverCell.self)
        tableView.registerCell(nib: DriverInviteFailCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

extension InviteDriverResultVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.currentTransCapacities.count == 0 {
            let cell = tableView.dequeueReusableCell(className: DriverInviteFailCell.self)
            return cell
        }
        let info = self.currentTransCapacities[indexPath.row]
        let cell = tableView.dequeueReusableCell(className: InviteDriverCell.self)
        cell.showInfo(name: info.driverName, phone: info.driverPhone, idCard: info.driverId)
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentTransCapacities.count == 0 && isLoaded == true {
            return 1
        }
        return self.currentTransCapacities.count
    }
}


extension InviteDriverResultVC {
    //MARK: - 搜索司机
    func searchDrivers() -> Void {
        self.showLoading()
        BaseApi.request(target: API.findCapacityByDriverNameOrPhone(driverPhone ?? ""), type: BaseResponseModel<[ZbnTransportCapacity]>.self)
            .retry(10)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: nil)
                self?.currentTransCapacities = data.data ?? []
                self?.isLoaded = true
                self?.tableView.reloadData()
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: {
                    self?.pop()
                })
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 点击邀请
    func tapInviteHandle() -> Void {
        
    }
    
    //MARK: - 点击添加
    func tapAddDriverHandle(index:Int?) -> Void {
        if index == nil {
            return
        }
        let info = currentTransCapacities[index!]
        BaseApi.request(target: API.addDriver(info.driverPhone), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: data.message, complete: {
                    self?.popCurrent(beforeIndes: 2, animation: true)
                })
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}

extension InviteDriverResultVC {
    override func routeName(routeName: String, dataInfo: Any?) {
        if routeName == "\(DriverInviteFailCell.self)" {
            tapInviteHandle()
        }
        if routeName == "\(InviteDriverCell.self)" {
            let cell = dataInfo as? InviteDriverCell
            if cell != nil {
                let indexPath = tableView.indexPath(for: cell!)
                if indexPath != nil {
                    tapAddDriverHandle(index: indexPath?.row)
                }
            }
        }
    }
}
