//
//  TransportCapacityVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let TOEDIT_TRANSPORT = "TOEDIT_TRANSPORT"  // 去编辑
let TODELE_TRANSPORT = "TODELE_TRANSPORT"  // 去删除

enum TransportCapacityShowType { // 当前展示的信息 ， 驾驶员 ， 车辆
    case Driver
    case Truck
}

class TransportCapacityVC: NormalBaseVC {
    
    private var searchBar:UISearchBar?
    private var showType:TransportCapacityShowType = .Truck
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSearchBar()
        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toReloadSearch()
    }
    
    override func currentConfig() {
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -3), opacity: 0.5, radius: 2)
        self.addNaviSelectTitles(titles: ["车辆","驾驶员"])
        self.addButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.bottomButtonHandle()
            })
            .disposed(by: dispose)
    }
    
    override func tapNaviHandler(index: Int) {
        if index == 0 {
            self.showType = .Truck
        } else {
            self.showType = .Driver
        }
        self.toReloadSearch()
        self.toReloadBottom()
        self.tableView.reloadData()
    }
}

// bussiness cell
extension TransportCapacityVC {
    
    func currentCell() -> UITableViewCell {
        switch self.showType {
        case .Truck:
            let cell = self.dequeueReusableCell(className: TransportTruckCell.self, for: self.tableView)
            return cell
        default:
            let cell = self.dequeueReusableCell(className: TransportDriverCell.self, for: self.tableView)
            return cell
        }
    }
}

extension TransportCapacityVC {
    // 添加车辆
    func toAddTrunck() -> Void {
        
    }
    // 添加驾驶员
    func toAddDriver() -> Void {
        
    }
}


// searchBar
extension TransportCapacityVC {
    func configSearchBar() -> Void {
        self.searchBar = UISearchBar()
        self.searchBar?.searchBarStyle = .minimal
        self.searchBar?.sizeToFit()
    }
    
    func toReloadSearch() -> Void {
        switch self.showType {
        case .Driver:
            self.searchBar?.placeholder = "搜索驾驶员姓名、电话"
            break
        default:
            self.searchBar?.placeholder = "搜索司机姓名、车牌号码"
        }
    }
}

//MARK: config tableView
extension TransportCapacityVC {
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.registerForNibCell(className: TransportDriverCell.self, for: tableView)
        self.registerForNibCell(className: TransportTruckCell.self, for: tableView)
    }
}

// 底部按钮
extension TransportCapacityVC {
    func toReloadBottom() -> Void {
        switch self.showType {
        case .Driver:
            self.addButton.setTitle("添加驾驶员", for: .normal)
            break
        default:
            self.addButton.setTitle("添加车辆", for: .normal)
        }
    }
    
    func bottomButtonHandle() -> Void {
        switch self.showType {
        case .Driver:
            self.toAddDriver()
            break
        default:
            self.toAddTrunck()
        }
    }
}

// control chain router
extension TransportCapacityVC {
    override func routeName(routeName: String, dataInfo: Any?) {
        print("routername : " + routeName)
        print(dataInfo ?? "")
    }
}

extension TransportCapacityVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.searchBar
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
