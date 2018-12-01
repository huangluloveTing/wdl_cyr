//
//  FocusResourceVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum FocusResourceDisplay {
    case focusPerson    // 关注托运人
    case focusLines     // 关注线路
}

class FocusResourceVC: MainBaseVC , ZTScrollViewControllerType {
    
    
    @IBOutlet weak var addLinesBtn: UIButton!
    @IBOutlet weak var focusPersonBtn: UIButton!
    @IBOutlet weak var focusLinesBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentTopIndex:Int = 0
    
    private var displayType:FocusResourceDisplay = .focusPerson
    private var list_tyr:[FollowShipperOrderHall] = []  //   关注的托运人的数据
    private var list_path:[FollowFocusLineOrderHallResult] = [] //   关注的线路的数据

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.toTapHeader(index: 0)
        self.tableView.beginRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       //需要下拉刷新
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func currentConfig() {
        
    }
    
    override func bindViewModel() {
        self.tableView.refreshState.share(replay: 1)
            .filter({(state) -> Bool in
                return state != .EndRefresh
            })
            .asDriver(onErrorJustReturn: .EndRefresh)
            .drive(onNext: { [weak self](state) in
                self?.tableView.endRefresh()
                self?.toLoadDataByTableViewHandle(state: state)
            })
            .disposed(by: dispose)
    }
    
    //MARK:
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    
    func registerAllCells() {
        self.registerCell(nibName: "\(FocusPersonCell.self)", for: self.tableView)
        self.registerCell(nibName: "\(FocusLinesCell.self)", for: self.tableView)
    }
    
    func configTableView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        self.registerAllCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.pullRefresh()
    }
    
    //MARK: 切换
    @IBAction func focusPersonAction(_ sender: UIButton) {
        self.toTapHeader(index: 0)
        self.tableView.reloadData()
    }
    @IBAction func focusLineAction(_ sender: UIButton) {
        self.toTapHeader(index: 1)
        self.tableView.reloadData()
    }
    @IBAction func addLinesAction(_ sender: Any) {
        self.toAddAction()
    }
}

extension FocusResourceVC { // 关注托运人或者关注线路 切换
    
    func currentDisplayContentType() -> FocusResourceDisplay {
        if self.currentTopIndex == 0 {
            return .focusPerson
        }
        return .focusLines
    }
    
    func toTapHeader(index:Int) -> Void {
        self.currentTopIndex = index
        if index == 0 {
            self.displayType = .focusPerson
            self.focusPersonBtn.isSelected = true
            self.focusLinesBtn.isSelected = false
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.loadResourceByAttentionCarrier()
        }
        else {
            self.displayType = .focusLines
            self.focusPersonBtn.isSelected = false
            self.focusLinesBtn.isSelected = true
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.loadResourceByAttentionPath()
        }
        self.tableView.reloadEmptyDataSet()
    }
    
    // 根据刷新的数据
    func toLoadDataByTableViewHandle(state:TableViewState) -> Void {
        let type = self.currentDisplayContentType()
        let index = type == .focusPerson ? 0 : 1
        self.toTapHeader(index: index)
    }
}

extension FocusResourceVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayType = self.currentDisplayContentType()
        //关注托运人
        if displayType == .focusPerson {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FocusPersonCell.self)") as! FocusPersonCell
            let info = self.list_tyr[indexPath.row]
            if info.total == 0 {
                cell.numberLabel.isHidden = true
            }else{
                cell.numberLabel.isHidden = false
            }
            cell.focusPersonInfo(image: info.loginPath, title: info.companyName, badge: info.total)
            return cell
        }
        else {
            //关注路线
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FocusLinesCell.self)") as! FocusLinesCell
            let info = self.list_path[indexPath.row]
            if info.total == 0 {
                cell.numberLabel.isHidden = true
            }else{
                cell.numberLabel.isHidden = false
            }
            cell.showInfo(start: (info.startProvince ?? "") + (info.startCity ?? ""),
                          end: (info.endProvince ?? "") + (info.endCity ?? ""),
                          badge: info.total)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = self.currentDisplayContentType()
        if type == .focusLines {
            return self.list_path.count
        }
        return self.list_tyr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayType = self.currentDisplayContentType()
        if displayType == .focusPerson {
            //关注托运人跳转详情页
            let shipper = self.list_tyr[indexPath.row]
            if shipper.hall.count == 0 {
                self.showWarn(warn: "当前关注的托运人没有任何货源数据！", complete: nil)
            }else{
                self.toAttentionConsignorDetail(consignor: shipper)
            }
            
        }
        else {
            //关注路线跳转详情页
            let line = self.list_path[indexPath.row]
            if line.hall.count == 0 {
                self.showWarn(warn: "当前关注的路线没有任何货源数据！", complete: nil)
            }else{
                self.toAttentionLineDetail(info: line)
            }
            
        }
    }
    
    
    // 侧滑删除，按下编辑按钮后执行（手势冲突，未解决）
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         //删除数组中的数据
        if displayType == .focusPerson {
            //取消关注托运人请求
            let info = self.list_tyr[indexPath.row]
            self.cancelFouceCarrier(code: info.consignorId, indexPath: indexPath)
        }
        else {
             //取消关注路线请求
            let info = self.list_path[indexPath.row]
            self.cancelFoucePath(lineCode: info.lineCode ?? "", indexPath: indexPath)
        }
       
    }
    
 
    //删除按钮文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注";
    }
    
}

extension FocusResourceVC {
   
    //取消关注托运人
    func cancelFouceCarrier(code: String, indexPath:IndexPath) -> Void {
        //托运人编码
        var cancelQuery = CancerFouceCarrier()
        cancelQuery.code = code
        self.showLoading()
        BaseApi.request(target: API.cancelFouceCarrier(cancelQuery), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
                //删除单元格
                self?.list_tyr.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    
    //取消关注路线
    func cancelFoucePath(lineCode: String, indexPath:IndexPath) -> Void {
      
        self.showLoading()
        BaseApi.request(target: API.cancelFoucePath(lineCode), type: BaseResponseModel<Any>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
                //删除单元格
                self?.list_path.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                }, onError: { [weak self](error) in
                    self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    
    
    // 获取关注的托运人的货源
    func loadResourceByAttentionCarrier() -> Void {
        self.showLoading()
        BaseApi.request(target: API.findOrderByFollowShipper(), type: BaseResponseModel<[FollowShipperOrderHall]>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
                self?.list_tyr = data.data ?? []
                self?.tableView.reloadData()
                self?.showAddButton()
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    // 获取关注的线路的货源
    func loadResourceByAttentionPath() -> Void {
        self.showLoading()
        BaseApi.request(target: API.findOrderByFollowLine(), type: BaseResponseModel<[FollowFocusLineOrderHallResult]>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess()
                self?.list_path = data.data ?? []
                self?.showAddButton()
                self?.tableView.reloadData()
            }, onError: {[weak self] (error) in
                self?.showFail(fail: error.localizedDescription)
            })
            .disposed(by: dispose)
    }
    
    // 展示添加 按钮
    func showAddButton() -> Void {
        switch self.displayType {
        case .focusPerson:
            if self.list_tyr.count > 0 {
                self.addLinesBtn.isHidden = false
            }
            else {
                self.addLinesBtn.isHidden = true
            }
            break
        default:
            if self.list_path.count > 0 {
                self.addLinesBtn.isHidden = false
            }
            else {
                self.addLinesBtn.isHidden = true
            }
        }
    }
    
    // emptyView button Handle
    func toAddAction() -> Void {
        switch self.displayType {
        case .focusPerson:
            self.toResearchConsignor()
            break
        default:
            self.toFocusLineVC()
        }
    }
}

extension FocusResourceVC { // EmptyDatasource
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed("\(FocusEmptyView.self)", owner: nil, options: nil)?.first as! FocusEmptyView
        let type = self.currentDisplayContentType()
        if type == .focusPerson {
            view.empty(title: "你还没有关注任何托运人",
                       desc: "赶紧去找找感兴趣的托运人吧",
                       buttonTitle: "添加关注托运人")
        }
        else {
            view.empty(title: "你还没有关注任何路线",
                       desc: "赶紧去找找感兴趣的路线吧",
                       buttonTitle: "添加关注线路")
        }
        // 自定义的view 的高度为0，需要加上高度约束
        view.snp.makeConstraints { [weak self](maker) in
            maker.height.equalTo((self?.tableView.zt_height)!)
        }
        view.tapClosure = { [weak self]() in
            self?.toAddAction()
        }
        return view
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
