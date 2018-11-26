//
//  ResourceHallVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ResourceHallVC: MainBaseVC , ZTScrollViewControllerType {
    
    @IBOutlet weak var endButton: MyButton!
    @IBOutlet weak var startButton: MyButton!
    @IBOutlet weak var statusButton: MyButton!
    @IBOutlet weak var dropAnchorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var startModel:SupplyPlaceModel = SupplyPlaceModel()
    private var endModel:SupplyPlaceModel = SupplyPlaceModel()
    private var listStatus:GoodsSupplyStatus?
    private var query : GoodsSupplyQueryBean = GoodsSupplyQueryBean()
    
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
            .subscribe(onNext: { () in
                self.showStatusDropView()
            })
            .disposed(by: dispose)
        
        //TODO:未做分页上拉刷新
        self.tableView.refreshState.share(replay: 1)
            .filter({(state) -> Bool in
                return state != .EndRefresh
            })
            .asDriver(onErrorJustReturn: .EndRefresh)
            .drive(onNext: { [weak self](state) in
                self?.tableView.endRefresh()
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
        placeView.dropClosure = { (province , city , strict) in
            self.startModel.province = province
            self.startModel.city = city
            self.startModel.strict = strict
            self.startButton.setTitle(strict?.title, for: .normal)
        }
        placeView.decideClosure = { [weak self](sure) in
            if sure == true {
                let strict = self?.startModel.strict
                self?.startButton.setTitle(strict?.title, for: .normal)
            } else {
                self?.startModel = SupplyPlaceModel()
                self?.startButton.setTitle("发货地", for: .normal)
            }
            self?.placeChooseView.hiddenDropView()
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
            self.endButton.setTitle(strict?.title, for: .normal)
        }
        placeView.decideClosure = { [weak self](sure) in
            if sure == true {
                let strict = self?.endModel.strict
                self?.endButton.setTitle(strict?.title, for: .normal)
            } else {
                self?.endModel = SupplyPlaceModel()
                self?.endButton.setTitle("发货地", for: .normal)
            }
            self?.endPlaceChooseView.hiddenDropView()
        }
        return self.addDropView(drop: placeView, anchorView: dropAnchorView)
    }()
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
                                          refercneceUnitPrice: hall.refercneceUnitPrice)
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
        resource.refercneceTotalPrice = hall.refercneceTotalPrice
        resource.refercneceUnitPrice = hall.refercneceUnitPrice
        resource.rate = 5
        resource.consignorName = hall.consignorName
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
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: nil)
                self?.configNetDataToUI(lists: data.data?.list ?? [])
            }, onError: {[weak self] (error) in
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
