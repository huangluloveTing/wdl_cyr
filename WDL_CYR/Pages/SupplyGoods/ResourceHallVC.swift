//
//  ResourceHallVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ResourceHallVC: MainBaseVC , ZTScrollViewControllerType {
    func willDisappear() {
        
    }
    
    
    @IBOutlet weak var endButton: MyButton!
    @IBOutlet weak var startButton: MyButton!
    @IBOutlet weak var statusButton: MyButton!
    @IBOutlet weak var dropAnchorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var startModel:SupplyPlaceModel = SupplyPlaceModel()
    private var endModel:SupplyPlaceModel = SupplyPlaceModel()
    private var listStatus:GoodsSupplyStatus?
    private var query : GoodsSupplyQueryBean = GoodsSupplyQueryBean()
    
    private var moreSelectItems:[MoreScreenSelectionItem] = []
    
    private var hallLists:[CarrierQueryOrderHallResult] = []
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.configTableView()
        self.queryResourceHall(quey: query)
        self.tableView.pullRefresh()
        self.loadAllMoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func bindViewModel() {
        self.startButton.rx.tap.asObservable()
            .subscribe(onNext: { [ weak self]() in
                self?.showPlaceDropView()
            })
            .disposed(by: dispose)
        self.endButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.showEndPlaceDropView()
            })
            .disposed(by: dispose)
        self.statusButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                if self?.moreSelectItems.count ?? 0 <= 0 {
                    self?.loadAllMoreData(toMore: true)
                    return
                }
                self?.showMoreSelection()
            })
            .disposed(by: dispose)
        
        //TODO:未做分页上拉刷新
        self.tableView.refreshState.share(replay: 1)
            .filter({(state) -> Bool in
                return state != .EndRefresh
            })
            .asDriver(onErrorJustReturn: .EndRefresh)
            .drive(onNext: { [weak self](state) in
//                self?.tableView.endRefresh()
                self?.queryResourceHall(quey: self!.query)
            })
            .disposed(by: dispose)
    }

    //MARK: Lazy
    // 状态下拉视图
    private lazy var statusView:DropViewContainer = {
        let statusView = GoodsSupplyStatusDropView(tags: GoodsStatus)
        statusView.checkClosure = { [weak self] (index) in
            if index == 0 {
                
            }
            self?.statusButton.setTitle(self?.GoodsStatus[index], for: .normal)
            self?.statusView.hiddenDropView()
        }
        return self.addDropView(drop: statusView, anchorView: self.dropAnchorView)
    }()
    
    //选择开始地区的下拉视图
    private lazy var placeChooseView:DropViewContainer = {
        let placeView = Bundle.main.loadNibNamed("DropPlaceView", owner: nil, options: nil)?.first as! DropPlaceChooiceView
        placeView.placeItems = self.initialProinve()
        placeView.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: IPHONE_WIDTH)
        placeView.dropClosure = { [weak self](province , city , strict) in
            self?.startModel.province = province
            self?.startModel.city = city
            let title = (city?.title != nil || city?.title.count ?? 0 > 0) ? city?.title : province?.title
            self?.startButton.setTitle(title, for: .normal)
        }
        placeView.decideClosure = { [weak self](sure) in
            if sure == true {
                let title = (self?.startModel.city?.title != nil || self?.startModel.city?.title.count ?? 0 > 0) ? self?.startModel.city?.title : self?.startModel.province?.title
                self?.startButton.setTitle(title, for: .normal)
                self?.query.startCity = self?.startModel.city?.title
                self?.query.startProvince = self?.startModel.province?.title
            } else {
                self?.startModel = SupplyPlaceModel()
                self?.startButton.setTitle("发货地", for: .normal)
                self?.query.startCity = ""
                self?.query.startProvince = ""
            }
            self?.placeChooseView.hiddenDropView()
            self?.tableView.beginRefresh()
        }
        return self.addDropView(drop: placeView, anchorView: dropAnchorView)
    }()
    
    //选择终点地区的下拉视图
    private lazy var endPlaceChooseView:DropViewContainer = {
        let placeView = Bundle.main.loadNibNamed("DropPlaceView", owner: nil, options: nil)?.first as! DropPlaceChooiceView
        placeView.placeItems = self.initialProinve()
        placeView.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: IPHONE_WIDTH)
        placeView.dropClosure = { (province , city , strict) in
            self.endModel.province = province
            self.endModel.city = city
            self.endModel.strict = strict
            let title = (city?.title != nil || city?.title.count ?? 0 > 0) ? city?.title : province?.title
            self.endButton.setTitle(title, for: .normal)
        }
        placeView.decideClosure = { [weak self](sure) in
            if sure == true {
                let title = (self?.endModel.city?.title != nil || self?.endModel.city?.title.count ?? 0 > 0) ? self?.endModel.city?.title : self?.endModel.province?.title
                self?.query.endCity = self?.endModel.city?.title
                self?.query.endProvince = self?.endModel.province?.title
                self?.endButton.setTitle(title, for: .normal)
            } else {
                self?.endModel = SupplyPlaceModel()
                self?.query.endCity = self?.endModel.city?.title
                self?.query.endProvince = self?.endModel.province?.title
                self?.endButton.setTitle("发货地", for: .normal)
            }
            self?.tableView.beginRefresh()
            self?.endPlaceChooseView.hiddenDropView()
        }
        return self.addDropView(drop: placeView, anchorView: dropAnchorView)
    }()
    
    
    override func callBackForRefresh(param: Any?) {
        let items = param as? [MoreScreenSelectionItem]
        moreSelectItems = items ?? []
        configQuery()
    }
}

//MARK: 注册cell / 配置tableView
extension ResourceHallVC {
    
    func registerCells() {
        self.registerCell(nibName: "\(ResourceHallCell.self)", for: self.tableView)
    }
    
    func configTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension ResourceHallVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.hallLists.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    //货源大厅列表数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResourceHallCell.self)") as! ResourceHallCell
        let hall = self.hallLists[indexPath.section]
        
        let truckInfo = Util.dateFormatter(date: hall.loadingTime/1000, formatter: "MM-dd") + " 装货 " + hall.goodsType
        let goodsInfo = Util.contact(strs: [String(format: "%.f", hall.goodsWeight)+"吨" , hall.vehicleLength , hall.vehicleType , hall.packageType], seperate: " | ")
        
        //参考价是否可见  var refercnecePriceIsVisable : String = "" // (string, optional), 参考价是否可见，1=可见 2，不可见
        
        let uiModel = ResourceHallUIModel(start: hall.startProvince + hall.startCity,
                                          end: hall.endProvince + hall.endCity,
                                          truckInfo: truckInfo,
                                          goodsInfo: goodsInfo,
                                          isSelf: true,
                                          company: hall.companyName,
                                          isAttention: hall.shipperCode.count > 0,
                                          unitPrice: hall.refercneceUnitPrice,
                                          companyLogo: hall.companyLogo,
                                          reportNum: hall.offerNumber,
                                          refercneceUnitPrice: hall.refercneceUnitPrice,
                                          refercnecePriceIsVisable: hall.refercnecePriceIsVisable,
                                          isOffer:hall.isOffer != nil && (hall.isOffer)!.count > 0)
        cell.showInfo(info: uiModel)
        cell.offerClosure = {[weak self] in
            self?.toOffer(index: indexPath.section)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.toResourceDetail(index: indexPath.section)
    }
    
    
    
}

extension ResourceHallVC {
    //MARK:
    func initialProinve() -> [PlaceChooiceItem] {
        return Util.configServerRegions(regions: WDLCoreManager.shared().regionAreas ?? [])
    }
    
    // 去货源详情
    func toResourceDetail(index:Int) -> Void {
        // 货源详情
        var resource = ResourceDetailUIModel()
        let hall = self.hallLists[index]
        resource.refercnecePriceIsVisable = hall.refercnecePriceIsVisable
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
        resource.consignorName = hall.companyName
        resource.resource = hall
        self.toResouceDetail(resource: resource)
    }
    
    // 去报价页面
    func toOffer(index:Int) -> Void {
        var resource = ResourceDetailUIModel()
        let hall = self.hallLists[index]
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
        resource.consignorName = hall.consignorName
        resource.resource = hall
        self.toChooseOfferType(resource: resource)
    }
}

//MARK: load data
extension ResourceHallVC {
    
    // 获取数据
    func queryResourceHall(quey:GoodsSupplyQueryBean) -> Void {
        self.showLoading(title: "", canInterface: true)
        BaseApi.request(target: API.findAllOrderHall(quey), type: BaseResponseModel<ResponsePagesModel<CarrierQueryOrderHallResult>>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.tableView.endRefresh()
                self?.showSuccess(success: nil)
                self?.configNetDataToUI(lists: data.data?.list ?? [])
            }, onError: {[weak self] (error) in
                self?.tableView.endRefresh()
                self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    // 根据获取数据,组装列表
    func configNetDataToUI(lists:[CarrierQueryOrderHallResult]) -> Void {
        self.hallLists = lists
        self.tableView.reloadData()
    }
}

// 添加 下拉选项 操作
extension ResourceHallVC {
    
    //MARK: - 点击更多筛选操作
    func showMoreSelection() -> Void {
        self.placeChooseView.hiddenDropView()
        self.endPlaceChooseView.hiddenDropView()
        let moreVC = MoreScreenSelectionVC()
        moreVC.currentSelectionItems = moreSelectItems
        self.pushToVC(vc: moreVC, title: "更多筛选")
    }
    
    func showStatusDropView() {
        self.placeChooseView.hiddenDropView()
        self.endPlaceChooseView.hiddenDropView()
        if self.statusView.isShow == false {
            self.statusView.showDropViewAnimation()
        } else {
            self.statusView.hiddenDropView()
        }
    }
    
    func showPlaceDropView() {
        self.statusView.hiddenDropView()
        self.endPlaceChooseView.hiddenDropView()
        if self.placeChooseView.isShow == false {
            self.placeChooseView.showDropViewAnimation()
        } else {
            self.placeChooseView.hiddenDropView()
        }
    }
    
    func showEndPlaceDropView() {
        self.statusView.hiddenDropView()
        self.placeChooseView.hiddenDropView()
        if self.endPlaceChooseView.isShow == false {
            self.endPlaceChooseView.showDropViewAnimation()
        } else {
            self.endPlaceChooseView.hiddenDropView()
        }
    }
}

//MARK: - 获取更多筛选的数据
extension ResourceHallVC {
    //MARK: - 组装 tableView 数据
    func configTableViewUIModels(select:MoreChooseItems?) {
        if let select = select {
            var consig = MoreScreenSelectionItem()
            consig.title = "托运人名称"
            consig.type = .input
            var inputItem = MoreScreenInputItem()
            inputItem.placeholder = "请输入货主名称"
            consig.inputItem = inputItem
            consig.queryKey = .consignorName
            
            var loadTimeItem = MoreScreenSelectionItem()
            loadTimeItem.title = "装货时间"
            var lengthItem = MoreScreenSelectionItem()
            lengthItem.title = "车长"
            var widthItem = MoreScreenSelectionItem()
            widthItem.title = "车宽"
            var typeItem = MoreScreenSelectionItem()
            typeItem.title = "车型"
            var tonsItem = MoreScreenSelectionItem()
            tonsItem.title = "吨位"
            let tons = select.OrderTonsLimit.map { (item) -> MoreScreenItem in
                var returnValue = MoreScreenItem()
                returnValue.title = item.dictionaryName ?? ""
                returnValue.select = false
                return returnValue
            }
            
            let widthItems = select.VehicleWidth.map { (item) -> MoreScreenItem in
                var returnValue = MoreScreenItem()
                returnValue.title = item.dictionaryName ?? ""
                returnValue.select = false
                return returnValue
            }
            
            let loadTimes = select.LoadingTime.map { (item) -> MoreScreenItem in
                var returnValue = MoreScreenItem()
                returnValue.title = item.dictionaryName ?? ""
                returnValue.select = false
                return returnValue
            }
            
            let lengthItems = select.VehicleLength.map { (item) -> MoreScreenItem in
                var returnValue = MoreScreenItem()
                returnValue.title = item.dictionaryName ?? ""
                returnValue.select = false
                return returnValue
            }
            
            let typeItems = select.VehicleType.map { (item) -> MoreScreenItem in
                var returnValue = MoreScreenItem()
                returnValue.title = item.dictionaryName ?? ""
                returnValue.select = false
                return returnValue
            }
        
            loadTimeItem.items = loadTimes
            loadTimeItem.type = .multiSelect
            loadTimeItem.queryKey = .loadingTime
            lengthItem.items = lengthItems
            lengthItem.type = .multiSelect
            lengthItem.queryKey = .vehicleLength
            widthItem.items = widthItems
            widthItem.type = .multiSelect
            widthItem.queryKey = .vehicleWidth
            typeItem.items = typeItems
            typeItem.type = .multiSelect
            typeItem.queryKey = .vehicleType
            tonsItem.items = tons
            tonsItem.type = .multiSelect
            tonsItem.queryKey = .weightStr
            
            moreSelectItems = [consig , loadTimeItem , lengthItem , widthItem , typeItem , tonsItem]
        }
    }
    
    
    //MARK: - 请求更多筛选相关的数据
    func loadAllMoreData(toMore:Bool? = false) -> Void {
        self.showLoading()
        BaseApi.request(target: API.getCarrierHallDictionary(), type: BaseResponseModel<MoreChooseItems>.self)
            .retry(10)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.configTableViewUIModels(select: data.data)
                if toMore == true {
                    self?.showMoreSelection()
                }
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}


extension ResourceHallVC {
    //MARK: - 根据筛选条件，组装查询条件
    func configQuery() -> Void {
        //MARK: - 承运人
        moreSelectItems.forEach { (item) in
            switch item.queryKey ?? .consignorName  {
            case .vehicleWidth:
                self.query.vehicleWidth = getSelectedItem(items: item.items)
                break
            case .vehicleType:
                self.query.vehicleType = getSelectedItem(items: item.items)
                break
            case .vehicleLength:
                self.query.vehicleLength = getSelectedItem(items: item.items)
                break
            case .vehicleWeight:
                break
            case .loadingTime:
                self.query.loadingTime = getSelectedItem(items: item.items)
                break
            case .consignorName:
                self.query.consignorName = item.inputItem?.input
                break
            case .weightStr:
                self.query.weightStr = getSelectedItem(items: item.items)
                break
            }
        }
        self.tableView.beginRefresh()
    }
    
    //MARK: - 获取选中的 item
    private func getSelectedItem(items:[MoreScreenItem]) -> String? {
        let items = items.filter { (screen) -> Bool in
            return screen.select
        }
        
        var param = ""
        items.forEach { (item) in
            if item.select == true {
                param.append(item.title)
            }
        }
        return param
    }
}
