//
//  ResourceHallVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit


let GoodsStatus = ["不限","竞价中","已成交","未上架","已上架"]

class ResourceHallVC: MainBaseVC , ZTScrollViewControllerType {
    
    @IBOutlet weak var endButton: MyButton!
    @IBOutlet weak var startButton: MyButton!
    @IBOutlet weak var statusButton: MyButton!
    @IBOutlet weak var dropAnchorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var startModel:SupplyPlaceModel = SupplyPlaceModel()
    private var endModel:SupplyPlaceModel = SupplyPlaceModel()
    private var listStatus:GoodsSupplyStatus?
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.configTableView()
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
    }

    //MARK: Lazy
    // 状态下拉视图
    private lazy var statusView:DropViewContainer = {
        let statusView = GoodsSupplyStatusDropView(tags: GoodsStatus)
        statusView.checkClosure = { [weak self] (index) in
            if index == 0 {
                
            }
            self?.statusButton.setTitle(GoodsStatus[index], for: .normal)
            
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
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResourceHallCell.self)") as! ResourceHallCell
        return cell
    }
}

extension ResourceHallVC {
    //MARK:
    func initialProinve() -> [PlaceChooiceItem] {
        return Util.configServerRegions(regions: WDLCoreManager.shared().regionAreas ?? [])
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
