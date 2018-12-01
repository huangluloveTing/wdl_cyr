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
    
    private var showType:TransportCapacityShowType = .Truck
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var vehicleLists:[ZbnTransportCapacity] = [] //所有的车辆数据
    private var driverLists:[ZbnTransportCapacity] = [] // 所有的司机数据
    
    private var driverSearch:String?
    private var vehicleSearch:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSearchBar()
        self.configTableView()
        tableView.beginRefresh()
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
        self.emptyTitle(title: "暂无信息", to: self.tableView)
    }
    
    override func tapNaviHandler(index: Int) {
        if index == 0 {
            self.showType = .Truck
        } else {
            self.showType = .Driver
        }
        self.toReloadSearch()
        self.toReloadBottom()
        decideToLoadData(index: index)
    }
}

//MARK: - bussiness cell
extension TransportCapacityVC {
    
    func currentCell(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        switch self.showType {
        case .Truck:
            let cell = self.dequeueReusableCell(className: TransportTruckCell.self, for: self.tableView)
            let info = self.vehicleLists[indexPath.section]
            cell.toShowInfo(truckNo: info.vehicleNo,
                            truckType: info.vehicleType,
                            truckLength: info.vehicleLength,
                            truckWeight: info.vehicleWeight,
                            extra: "",
                            canEdit: true)
            return cell
        default:
            let cell = self.dequeueReusableCell(className: TransportDriverCell.self, for: self.tableView)
            let info = self.driverLists[indexPath.section]
            cell.toShowInfo(driverName: info.driverName,
                            idCard: info.driverId,
                            phoneNum: info.driverPhone,
                            canEdit: true)
            return cell
        }
    }
}

//MARK: - handles
extension TransportCapacityVC {
    // 添加车辆
    func toAddTrunck() -> Void {
        
    }
    // 添加驾驶员
    func toAddDriver() -> Void {
        
    }
}


//MARK: - searchBar
extension TransportCapacityVC {
    func configSearchBar() -> Void {
        self.searchBar?.searchBarStyle = .minimal
        self.searchBar?.rx.text.orEmpty.asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](search) in
                self?.rxSearchHandle(search: search)
            })
            .disposed(by: dispose)
    }
    
    func rxSearchHandle(search:String) -> Void {
        switch self.showType {
        case .Driver:
            self.driverSearch = search
            self.loadData()
            break
        default:
            self.vehicleSearch = search
            self.loadData()
        }
    }
    
    func toReloadSearch() -> Void {
        switch self.showType {
        case .Driver:
            self.searchBar?.placeholder = "搜索驾驶员姓名、电话"
            self.searchBar?.text = self.driverSearch
            break
        default:
            self.searchBar?.placeholder = "搜索司机姓名、车牌号码"
            self.searchBar?.text = self.vehicleSearch
        }
    }
    
    
}

//MARK: - config tableView
extension TransportCapacityVC {
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.registerForNibCell(className: TransportDriverCell.self, for: tableView)
        self.registerForNibCell(className: TransportTruckCell.self, for: tableView)
        tableView.initEstmatedHeights()
        tableView.pullRefresh()
        tableView.refreshState.asObservable()
            .subscribe(onNext: { [weak self](state) in
                if state == .Refresh {
                    self?.loadData()
                }
            })
            .disposed(by: dispose)
    }
}

//MARK: - 底部按钮
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
    
    //MARK: - 根据点击的tab 和 当前数据情况，决定是否s重新获取数据
    func decideToLoadData(index:Int) -> Void {
        self.tableView.removeCacheHeights()
        if index == 0 {
            if self.vehicleLists.count <= 0 {
                self.tableView.beginRefresh()
                return
            }
        }
        if index == 1 {
            if self.driverLists.count <= 0 {
                self.tableView.beginRefresh()
                return
            }
        }
        self.tableView.reloadData()
    }
}

//MARK: - control chain router
extension TransportCapacityVC {
    override func routeName(routeName: String, dataInfo: Any?) {
        print("routername : " + routeName)
        print(dataInfo ?? "")
    }
}

//MARK: - TableViewDelegate / TableViewDataSource
extension TransportCapacityVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.showType {
        case .Driver:
            return self.driverLists.count
        default:
            return self.vehicleLists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.currentCell(indexPath: indexPath , tableView:tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightForRow(at: indexPath)
    }
}

//MARK: - 获取运力
extension TransportCapacityVC {
    
    func loadData() -> Void {
        if self.showType == .Driver {
            self.loadDriverCapacity(search: self.driverSearch ?? "")
        }
        else {
            self.loadVichelCapacity(search: self.vehicleSearch ?? "")
        }
    }
    
    //MARK: - 获取车辆数据
    func loadVichelCapacity(search:String) -> Void {
        self.tableView.removeCacheHeights()
        BaseApi.request(target: API.findCarInformation(search), type: BaseResponseModel<[ZbnTransportCapacity]>.self)
            .retry(10)
            .subscribe(onNext: { [weak self](data) in
                self?.tableView.endRefresh()
                self?.vehicleLists = data.data ?? []
                self?.tableView.reloadData()
            }, onError: { [weak self](error) in
                self?.tableView.endRefresh()
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 获取所有的司机数据
    func loadDriverCapacity(search:String) -> Void {
        self.tableView.removeCacheHeights()
        BaseApi.request(target: API.findDriverInformation(search), type: BaseResponseModel<[ZbnTransportCapacity]>.self)
            .retry(10)
            .subscribe(onNext: { [weak self](data) in
                self?.tableView.endRefresh()
                self?.driverLists = data.data ?? []
                self?.tableView.reloadData()
            }, onError: { [weak self](error) in
                self?.tableView.endRefresh()
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}
