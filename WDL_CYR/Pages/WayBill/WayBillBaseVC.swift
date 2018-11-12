//
//  WayBillBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


enum WaybillStatus {
    case unAssembleNoAccept     // 未配载订单来源为 1、2， 运单状态为待办单==0，司机状态为已配载==5, (接受和拒绝)
    case unAssembleSepecial     // 未配载订单来源为 3， 运单状态为待办单==0，司机状态为已配载==5,( 接受和拒绝)
    case unAssembleToDesignate  // 未配载的订单，发布的货源为无车报价时 运单状态为待办单==0 && 司机状态为无车竞价待指派==2 (指派)
    case unAssembleToAssemble   // 未配载的订单，发布的货源为有车报价时 运单状态为待办单 ==0 && 司机状态为未配载==0 （配载）
    case transporting           // transportStatus ,运输中
    case willTransport          // 待起运
    case willSign               // 待签收
    case breakContractForDriver // 司机违约     driverStatus = 6，role == 2  (继续运输 和 取消运输)
    case breakContractForCarrier// 承运人违约   driverStatus = 6，role == 1(修改配载)
    case doneNoComment          // 已完成订单无评价
    case doneOneComment         // 已完成订单一个评价
    case doneAllComment         // 已完成订单互评
    case noAnyHandle            // 没有任何操作的 ， 仅仅显示运单状态
}

enum CurrentTransportTab : Int{ // 当前运单的状态
    case UnAssemble  = 1    // 未配载
    case Doing  = 2         // 未完成
    case Done   = 3         // 已完成
}

/// 未配载
/// - 1、 由其他承运人成交后指派给你的运单信息（作为驾驶员情况，不可转）
/// - 2、 由TMS指定承运人，信息会同步到运单中（作为承运人，接受后可转给自己的驾驶员或者自己承运）
/// - 3、 特殊环节：由TMS指定承运人后发起运输计划，会显示在该栏目里面该条信息暂时没有（会有SAP订单号运单号（此时还未生成订单）承运人接受后，配载车辆和驾驶员信息+吨位分配，反馈到TMS，TMS配置好单车所装货物，WDL生成单个或多个运单（根据配载车辆而定，一车一个订单）。转入1或2
/// - 4、 由TMS获取代办货源信息，信息会放在无敌拉平台，承运人无车报价后自动成交，成交成功后在承运人端显示该条运单信息。可转由五得利周边第三方由托运人发布（自动或手动成交）货源信息，由承运人竞价成功后显示
/// 未接受
class WayBillBaseVC: MainBaseVC {
    
    private var currentTableView:UITableView!
    
    public var currentPageSize:Int = 20
    
    private var currentType:CurrentTransportTab = .UnAssemble
    
    // 状态下拉视图
    var statusView : GoodsSupplyStatusDropView?
    var timeChooseView : DropInputDateView?
    
    // 列表数据
    private var dataSource: [WayBillInfoBean] = []
    
    
    //请求参数
    public var queryBean : QuerytTransportListBean = QuerytTransportListBean()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Handles
    // 刷新的回调
    func headerRefresh() -> Void {}
    // 加载更多的回调
    func footerLoadMore() -> Void {}
    // 搜索的回调
    func currentSearch(text:String) -> Void {}
    
    // 当前状态数据
    func curreenStatusTitles() -> [String] {
        return GoodsStatus
    }
    
    //MARK: - lazy
    public lazy var loadTimeView : WaybillChangeLoadTimeView? = {
       let loadView = WaybillChangeLoadTimeView.instance()
        return loadView
    }()
    
    public var currentDataSource:[WayBillInfoBean] {
        return self.dataSource
    }
}

//MARK: - event chain
extension WayBillBaseVC {
    override func routeName(routeName: String, dataInfo: Any?) {
        let cell = dataInfo as? WaybillBaseCell
        let indexPath = self.currentTableView.indexPath(for: cell!)
        // 拒绝
        if routeName == EVENT_NAME_REJECT {
            self.toRejectWaybill(indexPath: indexPath)
        }
        // 接受
        if routeName == EVENT_NAME_RECEIVE {
            self.toReceiveWaybill(indexPath: indexPath)
        }
        // 取消运输
        if routeName == EVENT_NAME_CANCELTRANSPORT {
            self.toCancelTransport(indexPath: indexPath)
        }
        // 继续运输
        if routeName == EVENT_NAME_CONTINUETRANSPORT {
            self.toContinueTransport(indexPath: indexPath)
        }
        // 配载
        if routeName == EVENT_NAME_ASSEMBLE {
            self.toAssembleWaybill(indexPath: indexPath)
        }
        // 指派
        if routeName == EVENT_NAME_DESIGNATE {
            self.toDesiginWaybill(indexPath: indexPath)
        }
    }
}

//MARK: - handles
extension WayBillBaseVC {
    
    // 点击拒绝的回调
    func toRejectWaybill(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            showAlert(title: "提示", message: "确定要拒绝？") { [weak self](index) in
                if index == 1 {
                    self?.rejectTransportHandle(indexPath: indexPath)
                }
            }
        }
        
    }
    // 点击接受的回调
    func toReceiveWaybill(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            showAlert(title: "提示", message: "确定要接受？") { [weak self](index) in
                if index == 1 {
                    self?.receiveTransportHandle(indexPath: indexPath)
                }
            }
        }
    }
    // 点击指派的回调
    func toDesiginWaybill(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            let info = self.dataSource[indexPath.row - 1]
            self.designateTransportHandle(info: info , indexPath: indexPath)
        }
    }
    // 点击配载的回调
    func toAssembleWaybill(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            let info = self.dataSource[indexPath.row - 1]
            self.assembleTransportHandle(info: info)
        }
    }
    // 点击取消运输
    func toCancelTransport(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            showAlert(title: "提示", message: "确定要取消运输？") { [weak self](index) in
                if index == 1 {
                    self?.cancelTransportHandle(indexPath: indexPath)
                }
            }
        }
    }
    // 点击继续运输
    func toContinueTransport(indexPath:IndexPath?) -> Void {
        if let indexPath = indexPath {
            let info = self.dataSource[indexPath.row - 1]
            self.loadTimeView?.show(transportNo: info.transportNo ?? "")
        }
    }
    
    // 点击某一个 cell
    func toTapCell(indexPath:IndexPath) -> Void {
        // 没有接单，不进入详情
        let info = self.dataSource[indexPath.row - 1]
        let detailVC = WayBillDetailVC()
        detailVC.waybillInfo = info
        detailVC.transportNo = info.transportNo ?? ""
        let status = configWaybillStatus(info: info)
        switch status {
        case .unAssembleNoAccept:
            print("未接受不 跳转")
            return
        case .unAssembleSepecial:
            detailVC.currentShowMode(mode: .unassemble_showSpecial)
        case .unAssembleToDesignate:
            detailVC.currentShowMode(mode: .unassemble_showDesignate)
        case .unAssembleToAssemble:
            detailVC.currentShowMode(mode: .unassemble_showAssemble)
        case .transporting :
            detailVC.currentShowMode(mode: .doing_showTransporting)
        case .willTransport:
            detailVC.currentShowMode(mode: .doing_showWillTransport)
        case .willSign:
            detailVC.currentShowMode(mode: .doing_showWillSign)
        case .breakContractForDriver:
            print("已违约的司机 跳转 未实现")
            return
        case .breakContractForCarrier:
            detailVC.currentShowMode(mode: .doing_showNotStart)
        case .doneNoComment:
            detailVC.currentShowMode(mode: .done_notComment)
        default:
            detailVC.currentShowMode(mode: .done_commentOne)
        }
        self.push(vc: detailVC, title: "运单详情")
    }
}

//MARK: - bussiness
extension WayBillBaseVC {
    
    //MARK: - 拒绝
    func rejectTransportHandle(indexPath:IndexPath) -> Void {
        let info = self.dataSource[indexPath.row - 1]
        self.rejectTransportHandle(transportNo: info.transportNo ?? "") { (data) in
            self.deleteCurrentWaybill(indexPath: indexPath)
        }
    }
    
    //MARK: - 接受
    func receiveTransportHandle(indexPath:IndexPath) -> Void {
        let info = self.dataSource[indexPath.row - 1]
        self.receiveTransport(transportNo: info.transportNo ?? "") { (data) in
            self.convertWaybillToDesignate(indexPath: indexPath)
        }
    }
    
    //MARK: - 指派
    func designateTransportHandle(info:WayBillInfoBean , indexPath:IndexPath) -> Void {
        self.toChooseDriver(title: "指派") { [weak self](cap) in
            let phone = cap.driverPhone
            let code = info.transportNo
            self?.designateWaybill(phone: phone, transportNo: code ?? "", indexPath: indexPath)
        }
    }
    
    //MARK: - 配载
    func assembleTransportHandle(info:WayBillInfoBean) -> Void {
//        self.toAssemblePage(info: info)
    }
    
    //MARK: - 继续运输
    func continueTransportHandle(info:WayBillInfoBean , loadTime:TimeInterval , hallId:String) -> Void {
        self.continueTransport(transportNo: info.transportNo ?? "", loadTime: loadTime, hallId: hallId) { (data) in
            
        }
    }
    
    //MARK: -  取消运输
    func cancelTransportHandle(indexPath:IndexPath) -> Void {
        let info = self.dataSource[indexPath.row - 1]
        self.cancelTransport(transportNo: info.transportNo ?? "") { (data) in
            self.deleteCurrentWaybill(indexPath: indexPath)
        }
    }
    
    //MARK: -  未配载 司机接受 运单后，将订单变为 待配载运单
    func convertWaybillToDesignate(indexPath:IndexPath) -> Void {
        var info = self.dataSource[indexPath.row - 1]
        info.driverStatus = 4
        self.dataSource[indexPath.row - 1] = info
        self.currentTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: - 点击 拒绝 或者 取消运输，删除对应的运单信息
    func deleteCurrentWaybill(indexPath:IndexPath) -> Void {
        self.dataSource.remove(at: indexPath.row - 1)
        self.currentTableView.deleteRows(at: [indexPath], with: .none)
    }
}

// 筛选下拉视图
extension WayBillBaseVC : DropHintViewDataSource {
    
    func toConfigDropView(dropView:DropHintView) -> Void {
        dropView.dataSource = self
        dropView.tabTitles(titles: ["报价时间","报价状态"])
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        if index == 0 {
            if self.timeChooseView == nil {
                self.timeChooseView = DropInputDateView.instanceDateView()
                self.timeChooseView?.dropInputClosure = {[weak self](start , end , sure) in
                    self?.timeChooseHandle(startTime: start, endTime: end, tapSure: sure)
                }
            }
            return timeChooseView!
        } else {
            if self.statusView == nil {
                self.statusView = statusDropViewGenerate(statusTitles: curreenStatusTitles())
                
            }
            return self.statusView!
        }
    }
}

//MARK: cells
extension WayBillBaseVC {
    
    // 注册cell
    func registerAllCells(for tableView:UITableView) -> Void {
        tableView.registerCell(nib: WaybillCarrierInfoCell.self)
        tableView.registerCell(nib: WaybillSepecialInfoCell.self)
        tableView.registerCell(nib: WaybillNoHandleCell.self)
        tableView.registerCell(nib: OfferSearchCell.self)
    }
    
    // 配置当前tableView
    func configTableView(tableView:UITableView) -> Void {
        self.currentTableView = tableView
        self.currentTableView.delegate = self
        self.currentTableView.dataSource = self
        self.currentTableView.separatorStyle = .none
        self.currentTableView.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.registerAllCells(for: tableView)
    }
    
    // 配置 刷新
    func configHeaderAndFooterRefresh() -> Void {
        self.currentTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPageSize += 20
            self?.headerRefresh()
        })
        self.currentTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.currentPageSize = 20
            self?.footerLoadMore()
        })
    }
    
    // 结束刷新
    func endRefresh() -> Void {
        if let header = self.currentTableView.mj_header {
            header.endRefreshing()
        }
        if let footer = self.currentTableView.mj_footer {
            footer.endRefreshing()
        }
    }
    
    // noMoreData
    func endRefreshAndNoMoreData() -> Void {
        if let footer = self.currentTableView.mj_footer {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
    // reset footer
    func resetFooter() -> Void {
        if let footer = self.currentTableView.mj_footer {
            footer.resetNoMoreData()
        }
    }
    
    //
    func setCurrentTabStatus(tab:CurrentTransportTab) -> Void {
        self.currentType = tab
    }
    
    // begin refresh
    func beginRefresh() -> Void {
        if let header = self.currentTableView.mj_header {
            header.beginRefreshing()
        }
    }
}

//MARK: - 设置数据
extension WayBillBaseVC {
    func addContentItems(items:[WayBillInfoBean]) -> Void {
        self.dataSource.append(contentsOf: items)
        self.currentTableView.reloadData()
    }
    
    func refreshContents(items:[WayBillInfoBean]) -> Void {
        self.dataSource = items
        self.currentTableView.reloadData()
    }
}

//MARK: - load data
extension WayBillBaseVC {
    
    /// 顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,
    /// 运单状态：
    /// - 未配载 -1 不限 , 0 待办单
    /// - 未完成 -1 不限 , 0 待办单 1=待起运 2=运输中 3=待签收
    /// - 已完成 -1 不限 , 0 待办单 6=TMS签收
    fileprivate func loadWayBill(status:Int ,
                     transportStatus:Int = -1 ,
                     search:String? = nil ,
                     startTime:TimeInterval? = nil ,
                     endTime:TimeInterval? = nil,
                     closure:((WayBillPageBean?) ->())?){
        //token
        //self.queryBean.token = WDLCoreManager.shared().userInfo?.token ?? ""
        //self.queryBean.carrierId = WDLCoreManager.shared().userInfo?.carrierNo ?? ""
        // 顶部3个按钮状态 1：未配载，2 ：未完成， 3：完成 ,
        self.queryBean.completeStatus = status
        // 未配载
        // 运单状态： -1 不限 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收
        self.queryBean.transportStatus = transportStatus
        //搜索字段
        self.queryBean.searchWord = search
        //开始结束时间
        self.queryBean.startTime = startTime
        self.queryBean.endTime = endTime
        
        BaseApi.request(target: API.ownTransportPage(self.queryBean), type: BaseResponseModel<WayBillPageBean>.self)
            .subscribe(onNext: {[weak self](data) in
                self?.endRefresh()
                if let closure = closure {
                    closure(data.data)
                }
            }, onError: { [weak self](error) in
                self?.endRefresh()
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 获取未配载的信息
    func loadUnAssembleData(transportStatus:Int , startTime:TimeInterval? , endTime:TimeInterval? ,search:String? , closure:((WayBillPageBean?) ->())?) -> Void {
        loadWayBill(status: 1, transportStatus: transportStatus, search: search, startTime: startTime, endTime: endTime, closure: closure)
    }
    
    //MARK: - 获取未完成的信息
    func loadWayBillUnCompletedData(transportStatus:Int , startTime:TimeInterval? , endTime:TimeInterval? ,search:String? , closure:((WayBillPageBean?) ->())?) -> Void {
        loadWayBill(status: 2, transportStatus: transportStatus, search: search, startTime: startTime, endTime: endTime, closure: closure)
    }
    
    //MARK: - 获取已完成的信息
    func loadCompletedData(transportStatus:Int , startTime:TimeInterval? , endTime:TimeInterval? ,search:String? , closure:((WayBillPageBean?) ->())?) -> Void {
        loadWayBill(status: 3, transportStatus: transportStatus, search: search, startTime: startTime, endTime: endTime, closure: closure)
    }
    
    //MARK: - 承运人操作运单所有涉及的按钮请求（拒绝，接受，取消运输，继续运输）
    //    hallId (string): 货源id ,(只有在操作 - 继续运输 提交时间才将hallid传入)
    //    status (integer): 操作类型（3=拒绝，4=接受，8=取消运输，7=继续运输） ,
    //    loadingTime (string, optional): （继续运输时）装货时间 ,
    //    transportNo (string): 运单号
    fileprivate func transportHandle(status:Int ,
                         transportNo:String ,
                         loadingTime:TimeInterval? = nil ,
                         hallId:String? ,
                         closure:((Any) -> ())?){
        BaseApi.request(target:  API.carrierAllButtonAcceptTransportState(status, loadingTime, transportNo , hallId), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: { (model) in
                if let closure = closure {
                    closure(model)
                }
            }, onError: { (error) in
                self.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    // 拒绝
    func rejectTransportHandle(transportNo:String,
                               closure:((Any) -> ())?) -> Void {
        transportHandle(status: 3, transportNo: transportNo, hallId: nil, closure: closure)
    }
    
    // 接受
    func receiveTransport(transportNo:String , closure:((Any) -> ())?) -> Void {
        transportHandle(status: 4, transportNo: transportNo, hallId: nil, closure: closure)
    }
    
    // 取消运输
    func cancelTransport(transportNo:String , closure:((Any) -> ())?) -> Void {
        transportHandle(status: 7, transportNo: transportNo, hallId: nil, closure: closure)
    }
    
    // 继续运输
    func continueTransport(transportNo:String ,
                           loadTime:TimeInterval ,
                           hallId:String ,
                           closure:((Any) -> ())?) -> Void {
        transportHandle(status: 7, transportNo: transportNo,loadingTime: loadTime , hallId: hallId, closure: closure)
    }
    
    // a指派
    func designateWaybill(phone:String , transportNo:String , indexPath:IndexPath) -> Void {
        self.showLoading()
        BaseApi.request(target: API.designateWaybill(phone, transportNo), type: BaseResponseModel<String>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.deleteCurrentWaybill(indexPath: indexPath)
            }, onError: {[weak self] (error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}

//MARK: - UITableViewDelegate , UITableViewDataSource
extension WayBillBaseVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(nib: OfferSearchCell.self)
            cell.searchClosure = {[weak self] (text) in
                self?.currentSearch(text: text)
            }
            return cell
        }
        var newIndexPath = indexPath
        newIndexPath.row = indexPath.row - 1
//        return self.currentCell(tableView:tableView , indexPath:newIndexPath)
        return currentWaybillCell(indexPath: newIndexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        cell.contentView.shadowBorder(radius: 8,
                                      bgColor: UIColor.white,
                                      shadowColor: UIColor(hex: COLOR_SHADOW),
                                      shadowOffset: CGSize(width: 1, height: 1),
                                      shadowOpacity: 0.4,
                                      insets: UIEdgeInsetsMake(0, 15, 15, 15))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.toTapCell(indexPath: indexPath)
    }
}

//MARK: - 运单逻辑判断 1 =================

extension WayBillBaseVC {
    func currentCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let info = self.dataSource[indexPath.row]
        switch self.currentType {
        case .UnAssemble: // 当前为未配载的情况
            if info.comeType == 1 || info.comeType == 2 {
                return self.showUnAssembleTwoHandlesCell(info: info, indexPath: indexPath, tableView: tableView)
            }
            if info.comeType == 3 {
                return showUnAssembleTwoHandlesCellNoTruckInfo(info: info, indexPath: indexPath, tableView: tableView)
            }
            return showUnAssembleOneHandleCell(info: info, indexPath: indexPath, tableView: tableView)
        case .Doing:
            if info.transportStatus == 0 { // 为待办单时
                if info.driverStatus == 6 { // 已违约
                    if info.role == 1 { // 承运人角色
                        return notDoneBreakContractCell(info: info, tableView: tableView)
                    }
                    return notDoneDriverBreakContractCell(info: info, tableView: tableView) // 司机角色
                }
                else { // 没有违约
                    return notDoneNormalContractCell(info: info, tableView: tableView)
                }
            }
            return notDoneNomalCell(info: info, tableView: tableView)
        default:
            return doneWaybillCell(info: info, tableView: tableView)
        }
    }
}

//1：未配载
// info.comeType
// 4种类型判断展示 comeType: 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= 个人指派（按照rp顺序）,
// driverStatus : Int? // (integer): 当前司机是否接受过改订单  4=接受，接受指派隐藏按钮，否则为没有进行过任何操作，显示两个按钮
//MARK: - 未配载 相关的cell
extension WayBillBaseVC {
    
    // 特殊环节：由TMS指定承运人后发起运输计划，会显示在该栏目里面该条信息暂时没有（会有SAP订单号）
    // 运单号（此时还未生成订单）承运人接受后，配载车辆和驾驶员信息+吨位分配，反馈到TMS，TMS配置好
    // 单车所装货物，WDL生成单个或多个运单（根据配载车辆而定，一车一个订单）
    // 订单来源为 1、2 的时候，即显示 拒绝和接受 按钮的样式 , 无车辆信息的情况
    func showUnAssembleTwoHandlesCell(info:WayBillInfoBean ,
                                      indexPath:IndexPath ,
                                      tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.contentInfo(info:info , currentBtnIndex: self.currentType.rawValue)
        return cell
    }
    
    // 订单来源为 3 的时候，即显示 拒绝和接受 按钮的样式 ， 无车辆i信息的情况
    func showUnAssembleTwoHandlesCellNoTruckInfo(info:WayBillInfoBean? ,
                                             indexPath:IndexPath ,
                                             tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillSepecialInfoCell.self)
        cell.contentInfo(info: info)
        return cell
    }
    
    // 订单来源为 4 的时候，即显示 指派 按钮的样式
    func showUnAssembleOneHandleCell(info:WayBillInfoBean ,
                                     indexPath:IndexPath ,
                                     tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.contentInfo(info: info, currentBtnIndex: self.currentType.rawValue)
        return cell
    }
}

//MARK: - 未完成
/// transportStatus 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派 ,
/// driverStatus 可用于判断违约状态 6=已违约 7=违约继续承运 8=违约放弃承运
/// 当为待办单时 ， 即transportStatus = 0 ，
/// - driverStatus = 6 已违约时，当角色是司机时（role == 2）当前是承运人角色是司机状态可修改配载时间(显示取消运输，继续运输两个按钮)在点击继续运输修改时间需要判断orderAvailabilityPeriod 货源有效期这个字段 当角色是承运人时（role == 1) 显示 配载
/// - 当没有违约时，显示 接受 和 拒绝 两个按钮
/// 别的情况，无按钮，显示对应的状态
extension WayBillBaseVC {
    
    // 为待办单，且已违约的情况，角色为司机的情况,显示两个按钮， 即取消运输和继续运输
    func notDoneDriverBreakContractCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.contentInfo(info: info, currentBtnIndex: 2)
        return cell
    }
    
    // 为待办单，且已违约的情况，角色为承运人的情况,显示一个按钮， 即修改配载
    func notDoneBreakContractCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.contentInfo(info: info, currentBtnIndex: 2)
        return cell
    }
    
    // 为待办单，且没有违约的情况，显示两个按钮， 即取消运输和继续运输
    func notDoneNormalContractCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.contentInfo(info: info, currentBtnIndex: 2)
        return cell
    }
    
    // 未完成 ， 其他运单状态的cell ， 即显示对应的状态的 cell ， 无操作情况
    func notDoneNomalCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillNoHandleCell.self);
        cell.contentInfo(info: info, currentBtnIndex: 2)
        return cell;
    }
}

//MARK: - 已完成的运单
// 依次判断 comeType 运单来源， evaluateCode 不为空，表示承运人已经评价 ,
extension WayBillBaseVC {
    
    func doneWaybillCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillNoHandleCell.self)
        cell.contentInfo(info: info, currentBtnIndex: 3)
        return cell
    }
}

//MARK: - 运单逻辑判断 2  =========

// 匹配对应的运单状态
extension WayBillBaseVC {
    
    //MARK: - 根据运单状态，配置对应的状态
    func configWaybillStatus(info:WayBillInfoBean) -> WaybillStatus {
        let transportStatus = info.transportStatus ?? 0 // 运单状态 1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派
        let comType = info.comeType         // 运单来源 1=其他承运人指派 2=tms指派 3=运输计划 4= ,
        let driverStatus = info.driverStatus ?? 0 // 司机状态 0=未配载 1=TMS指派 (只要生成定单，就表明一定是已指派)2=无车竞价待指派 3=拒绝指派 4=接受指派 5=已配载 6=已违约 7=违约继续承运 8=违约放弃承运 ,
        let role = info.role            // 1 承运人 ，2 司机
        let evalate = (info.evaluateCode != nil)
        if comType == 1 {   // 来源1
            if transportStatus == 0 { // 待办单
                if driverStatus == 4 {  // 未接受
                    return .unAssembleToAssemble
                }
                if driverStatus == 6 { // 已违约的情况
                    if role == 2 {
                        return .breakContractForDriver
                    }
                    return .breakContractForCarrier
                }
                return .unAssembleNoAccept
            }
        }
        
        if comType == 2 { // 来源2
            if transportStatus == 0 { // 待办单
                if driverStatus == 4 {  // 未接受
                    return .unAssembleToAssemble
                }
                if driverStatus == 6 { // 已违约的情况
                    if role == 2 {
                        return .breakContractForDriver
                    }
                    return .breakContractForCarrier
                }
                return .unAssembleNoAccept
            }
        }
        
        if comType == 3 {
            if transportStatus == 0 { // 待办单
                if driverStatus == 4 {  // 未接受
                    return .unAssembleToAssemble
                }
                if driverStatus == 6 { // 已违约的情况
                    if role == 2 {
                        return .breakContractForDriver
                    }
                    return .breakContractForCarrier
                }
                return .unAssembleNoAccept
            }
        }
        
        if comType == 4 {
            if transportStatus == 0 { // 待办单
                if driverStatus == 4 {  // 已接受
                    return .unAssembleToDesignate
                }
                if driverStatus == 6 { // 已违约的情况
                    if role == 2 {
                        return .breakContractForDriver
                    }
                    return .breakContractForCarrier
                }
                return .unAssembleNoAccept
            }
        }
        
        if transportStatus == 1 {
            return .willTransport
        }
        if transportStatus == 2 {
            return .transporting
        }
        if transportStatus == 3 {
            return .willSign
        }
        if transportStatus > 3 {
            if evalate == true {
                return .doneAllComment
            }
            else {
                return .doneNoComment
            }
        }
        
        return .noAnyHandle
    }
    
    
//    case unAssembleNoAccept     // 未配载订单来源为 1、2， 运单状态为待办单==0，司机状态为已配载==5, (接受和拒绝)
//    case unAssembleSepecial     // 未配载订单来源为 3， 运单状态为待办单==0，司机状态为已配载==5,( 接受和拒绝)
//    case unAssembleToDesignate  // 未配载的订单，发布的货源为无车报价时 运单状态为待办单==0 && 司机状态为无车竞价待指派==2 (指派)
//    case unAssembleToAssemble   // 未配载的订单，发布的货源为有车报价时 运单状态为待办单 ==0 && 司机状态为未配载==0 （配载）
//    case transporting           // transportStatus ,运输中
//    case willTransport          // 待起运
//    case willSign               // 待签收
//    case breakContractForDriver // 司机违约     driverStatus = 6，role == 2  (继续运输 和 取消运输)
//    case breakContractForCarrier// 承运人违约   driverStatus = 6，role == 1(修改配载)
//    case doneNoComment          // 已完成订单无评价
//    case doneOneComment         // 已完成订单一个评价
//    case doneAllComment         // 已完成订单互评
//    case noAnyHandle            // 没有任何操作的 ， 仅仅显示运单状态
    func currentWaybillCell(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let info = self.dataSource[indexPath.row]
        let status = configWaybillStatus(info: info)
        switch status {
        case .unAssembleNoAccept:
            return unAssembleNoAcceptCell(info: info, tableView: tableView)
        case .unAssembleSepecial:
            return unAssembleSepecialCell(info: info, indexPath: indexPath, tableView: tableView)
        case .unAssembleToDesignate:
            return showUnAssembleOneHandleCell(info: info, indexPath: indexPath, tableView: tableView)
        case .unAssembleToAssemble:
            return unAssembleToAssembleCell(info: info, tableView: tableView)
        case .transporting , .willSign , .willTransport:
            return noHandleCell(info: info, tableView: tableView)
        case .breakContractForDriver:
            return breakContractForDriverCell(info: info, tableView: tableView)
        case .breakContractForCarrier:
            return breakContractForCarrierCell(info: info, tableView: tableView)
        case .doneNoComment:
            return noHandleCell(info: info, tableView: tableView)
        default:
            return noHandleCell(info: info, tableView: tableView)
        }
    }
    
    
    // unAssembleNoAccept
    func unAssembleNoAcceptCell(info:WayBillInfoBean? ,tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.showInfoAcceptAndReject(info: info)
        return cell
    }
    // unAssembleSepecial
    func unAssembleSepecialCell(info:WayBillInfoBean? ,indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        return showUnAssembleTwoHandlesCellNoTruckInfo(info: info, indexPath: indexPath, tableView: tableView)
    }
    
    // unAssembleToDesignate
    func unAssembleToDesignateCell(info:WayBillInfoBean? , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.showInfoWillDesigned(info: info)
        return cell
    }
    
    // unAssembleToAssemble
    func unAssembleToAssembleCell(info:WayBillInfoBean? , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.showInfoWillAssemble(info: info)
        return cell
    }
    // transporting , willTransport , willSign
    func noHandleCell(info:WayBillInfoBean? , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillNoHandleCell.self);
        cell.showInfo(info: info)
        return cell;
    }
    
    // breakContractForDriver
    func breakContractForDriverCell(info:WayBillInfoBean? , tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.showInfoAcceptAndReject(info: info)
        return cell
    }
    
    // breakContractForCarrier
    func breakContractForCarrierCell(info:WayBillInfoBean? ,tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillCarrierInfoCell.self)
        cell.showInfoDoingBreakContract(info: info)
        return cell
    }
    
    // doneNoComment
    func doneNoCommentCell(info:WayBillInfoBean? , tableView:UITableView) -> UITableViewCell {
        return self.noHandleCell(info:info , tableView:tableView)
    }
    
    // some other
    func doneCommentedCell(info:WayBillInfoBean , tableView:UITableView) -> UITableViewCell {
        return noHandleCell(info:info , tableView:tableView)
    }
}


//  1=待起运 0=待办单 2=运输中 3=待签收 4=司机签收 5=经销商或第三方签收 6=TMS签收 7=TMS指派 8=拒绝指派 ,
//总体备注== 承运人登录：driverId != userId ；司机登录：driverId == userId
//未配载==0(有车报价) 和 无车竞价待指派==2（无车报价） 相当于一个概念都是未配载 可以理解为：有车报价未配载和无车报价未配载
//
//承运人可看的按钮“配载”：发布的货源为有车报价时 运单状态为待办单 ==0 && 司机状态为未配载==0
//
//承运人可看的按钮“指派”：发布的货源为无车报价时 运单状态为待办单==0 && 司机状态为无车竞价待指派==2
//
//司机可看的按钮“接 受 / 拒 绝”：承运人指派后（运单状态为待办单==0，司机状态为已配载==5），司机态可以操作 接受和拒绝
//
//司机可看的按钮“配载”：司机接受配载后，可以重新更新配载，只能更改运输车辆信息 并且 只能选择自己名下的车辆信息
