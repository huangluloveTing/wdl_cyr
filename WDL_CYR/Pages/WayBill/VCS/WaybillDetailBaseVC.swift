//
//  WaybillDetailBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

struct ToCommentModel {
    var logicRate:Int = 0
    var serviceRate:Int = 0
    var comment:String?
}

enum WaybillDisplayMode {
    case unassemble_showAssemble    //未配载，显示配载的情况，即订单来源为 1、2 的情况
    case unassemble_showSpecial     //未配载，运单来源为3 的情况
    case unassemble_showDesignate   //未配载，运单来源为4 的情况
    case doing_showWillTransport    //未完成，待起运
    case doing_showTransporting     //未完成，运输中
    case doing_showWillSign         //未完成，待签收
    case doing_showNotStart         //未完成的待办单
    case done_notComment            //已完成，未评价
    case done_commentOne            //已完成，一个评价
    case done_commentAll            //已完成，互评
}

class WaybillDetailBaseVC: NormalBaseVC {
    
    private var currentTableView:UITableView?
    
    private var currentDisplayMode:WaybillDisplayMode?
    
    private var currentInfo:TransactionInformation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // 点击 对应的操作（指派，配载，修改配载）
    public func handleAction() {}
    
    // 当前的回执单数据
    func currentReturnLists() -> [ZbnTransportReturn] {
        return []
    }
    // 当前的一个评论数据
    func currentOneCommet() -> WayBillDetailCommentInfo? {
        return nil
    }
    // 已互评的数据
    func currentCommentAll() -> (WayBillDetailCommentInfo?, WayBillDetailCommentInfo?) {
        return (nil , nil)
    }
    // 我的去评论的数据--- 需重写获取评论数据
    func toComment(comment:ToCommentModel) -> Void {
    }
    // 提交评论 --- 需重写提交评论数据
    func toCommitComment() -> Void {
    }
}

//MARK: - config tableView
extension WaybillDetailBaseVC {
    
    func configTableView(tableView:UITableView) -> Void {
        currentTableView = tableView
        currentTableView?.delegate = self
        currentTableView?.dataSource = self
        currentTableView?.separatorColor = UIColor(hex: "dddddd")
        currentTableView?.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0)
        registerAllCells()
    }
    
    func registerAllCells() -> Void {
        currentTableView?.registerCell(nib: WayBillDetailStatusCell.self)
        currentTableView?.registerCell(nib: WaybillLinkInfoCell.self)
        currentTableView?.registerCell(nib: WaybillGoodsInfoCell.self)
        currentTableView?.registerCell(nib: WaybillDealInfoCell.self)
        currentTableView?.registerCell(nib: WaybillHandleCell.self)
        currentTableView?.registerCell(nib: WayBillReceiptCell.self)
        currentTableView?.registerCell(nib: WayBillToCommentCell.self)
        currentTableView?.registerCell(nib: WayBillCommentAllCell.self)
        currentTableView?.registerCell(nib: WayBillOneCommentCell.self)
    }
    
    //MARK: - 配置当前页面的展示模式
    func currentShowMode(mode:WaybillDisplayMode) -> Void {
        currentDisplayMode = mode
    }
    
    //MARK: - 当前页面数据
    func showCurrentPageInfo(info:TransactionInformation?) -> Void {
        currentInfo = info
        self.reloadTableView()
    }
    
    //配置当前的显示
    
    
    //刷新页面
    func reloadTableView() -> Void {
        guard let mode = currentDisplayMode else {
            assert(true, "必须设置该页面的展示方式")
            return
        }
        print(mode)
        currentTableView?.reloadData()
    }
}

//MARK: - UITableViewDelegate , UITableViewDataSource
extension WaybillDetailBaseVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentCell(tableView:tableView , indexPath:indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSectionRows(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - 根据当前页面的状态，配置cell
extension WaybillDetailBaseVC {
    func currentCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        switch self.currentDisplayMode! {
        case .unassemble_showAssemble:
            return unAssembleToAssemble(indexPath: indexPath, tableView: tableView)
        case .unassemble_showSpecial:
            return unAssembleSepecialToAssemble(indexPath: indexPath, tableView: tableView)
        case .unassemble_showDesignate:
            return unAssembleToDesignate(indexPath: indexPath, tableView: tableView)
        case .doing_showNotStart:
            return notDoneNotStartCell(tableView:tableView , indexPath:indexPath)
        case .doing_showWillSign:
            return notDoneWillSignCell(tableView: tableView ,indexPath:indexPath)
        case .doing_showTransporting:
            return notDoneTransportingCell(tableView: tableView , indexPath:indexPath)
        case .doing_showWillTransport:
            return notDoneWillStartCell(tableView:tableView , indexPath:indexPath)
        case .done_notComment:
            return doneToCommentCell(tableView:tableView , indexPath:indexPath)
        case .done_commentAll , .done_commentOne:
            return doneCommentedCell(tableView:tableView , indexPath:indexPath)
        }
    }
    
    func currentSections() -> Int {
        //如果没有数据，不显示任何数据
        guard self.currentInfo != nil else {
            return 0
        }
        switch self.currentDisplayMode! {
        case .unassemble_showAssemble , .unassemble_showDesignate:
            return unAssembleToDesignateNumSection()
        case .unassemble_showSpecial:
            return unAssembleSepecialToDesignateNumSection()
        case .doing_showWillTransport:
            return notDoneWillStartNumSection()
        case .doing_showTransporting:
            return notDoneTransportingNumSection()
        case .doing_showWillSign:
            return notDoneWillSignNumSection()
        case .doing_showNotStart:
            return notDoneNotStartNumSection()
        case .done_commentOne , .done_commentAll:
            return doneCommentedtNumSection()
        case .done_notComment:
            return doneToCommentNumSection()
        }
    }
    
    func tableViewSectionRows(section:Int) -> Int {
        switch self.currentDisplayMode! {
        case .unassemble_showAssemble , .unassemble_showDesignate:
            return unAssembleToDesignateRows(section:section)
        case .unassemble_showSpecial:
            return unAssembleSepecialToDesignateRows(section:section)
        case .doing_showWillTransport:
            return notDoneWillStartRow(section:section)
        case .doing_showTransporting:
            return notDoneTransportingRow(section:section)
        case .doing_showWillSign:
            return notDoneWillSignRow(section:section)
        case .doing_showNotStart:
            return notDoneNotStartRow(section:section)
        case .done_commentOne , .done_commentAll:
            return doneCommentedRows(section:section)
        case .done_notComment:
            return doneToCommentRow(section:section)
        }
    }
}


//MARK: - generate cell
extension WaybillDetailBaseVC {
    //MARK: - 运单状态的cell
    func waybillStatusCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillDetailStatusCell.self)
        cell.showInfo(status:  self.currentInfo?.transportStatus ?? .noStart)
        return cell
    }
    //MARK: - 联系人信息的cell
    func waybillLinkInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillLinkInfoCell.self)
        cell.showInfo(sendName: self.currentInfo?.loadingPersonName,
                      loadPhone: self.currentInfo?.loadingPersonPhone,
                      loadAddress: self.currentInfo?.startAddress,
                      consignee: self.currentInfo?.consigneeName,
                      consigneeAddress: self.currentInfo?.endAddress,
                      carrier: self.currentInfo?.carrierName,
                      driver: self.currentInfo?.dirverName,
                      vehicleNo: self.currentInfo?.vehicleNo)
        return cell
    }
    //MARK: - 指派，配载等操作d相关的cell
    func waybillHandleCell(tableView:UITableView , handleName:String?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillHandleCell.self)
        cell.showHandleName(name: handleName)
        return cell
    }
    
    //MARK: - 成交信息相关的cell
    func waybillDealInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillDealInfoCell.self)
        cell.showInfo(time: (self.currentInfo?.dealTime ?? 0) / 1000,
                      unit: Float(self.currentInfo?.dealUnitPrice ?? 0),
                      total: Float(self.currentInfo?.dealTotalPrice ?? 0),
                      serviceFee: self.currentInfo?.infoFee,
                      capacity: self.currentInfo?.goodsWeight)
        return cell
    }
    
    //MARK: - 货源信息相关e的cell
    func waybillGoodsInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillGoodsInfoCell.self)
        let dealTime = (self.currentInfo?.dealTime ?? 0) / 1000
        let start = Util.contact(strs: [self.currentInfo?.startProvince ?? "" , self.currentInfo?.startCity ?? "" , self.currentInfo?.startAddress ?? ""])
        let end = Util.contact(strs: [self.currentInfo?.endProvince ?? "" , self.currentInfo?.endCity ?? "" , self.currentInfo?.endAddress ?? ""])
        cell.showGoodsInfo(dealTime: dealTime, start: start,
                           end: end, goodsType: self.currentInfo?.goodsType,
                           loadTime: (self.currentInfo?.loadingTime ?? 0)/1000,
                           weight: self.currentInfo?.goodsWeight,
                           pacakge: self.currentInfo?.packageType,
                           length: self.currentInfo?.vehicleLength,
                           vehicleType: self.currentInfo?.vehicleType)
        return cell
    }
    
    //MARK: - 运单回单的相关功能
    func waybillReturnListCell(tableView:UITableView , canEdit:Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillReceiptCell.self)
        cell.maxPic = 3
        let returnLists = currentReturnLists()
        cell.showReceiptInfo(info: returnLists)
        return cell
    }
    
    //MARK: - 未评价，评价运单的cell
    func waybillToCommentCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillToCommentCell.self)
        cell.commentClosure = {[weak self] (logic , service , comment) in
            let model = ToCommentModel(logicRate: Int(logic), serviceRate: Int(service), comment: comment)
            self?.toComment(comment: model)
        }
        cell.commitClosure = {[weak self] in
            self?.toCommitComment()
        }
        return cell
    }
    
    //MARK: - 已完成，展示一个评价信息的cell
    func waybillOneCommentCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillOneCommentCell.self)
        cell.showComment(info: currentOneCommet())
        return cell
    }
    
    //MAKR: - 已完成，展示互评的cell
    func waybillCommentAllCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillCommentAllCell.self)
        let (toMeComment , myComment ) = self.currentCommentAll()
        cell.showCommentInfo(toMeinfo: toMeComment, myCommentInfo: myComment)
        return cell
    }
}


//MARK:  根据当前的运单状态，展示对应的cell
//MARK: - 未配载，显示配载的情况，即订单来源为 1、2 的情况 ， 当订单来源为 4 时 ， z配置 变为 指派，其他一样的
extension WaybillDetailBaseVC {
    
    func unAssembleToDesignateNumSection() -> Int {
        return 3
    }
    
    func unAssembleToDesignateRows(section:Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    // 当运单来源为 1，2 时 ， 对应的cell
    func unAssembleToAssemble(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
            if row == 2 {
                return waybillHandleCell(tableView: tableView, handleName: "配载")
            }
        }
        if section == 1 {
            return waybillDealInfoCell(tableView: tableView)
        }
        return waybillGoodsInfoCell(tableView: tableView)
    }
    
    // 当运单来源为 4 时 ， 对应的cell
    func unAssembleToDesignate(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
            if row == 2 {
                return waybillHandleCell(tableView: tableView, handleName: "指派")
            }
        }
        if section == 1 {
            return waybillDealInfoCell(tableView: tableView)
        }
        return waybillGoodsInfoCell(tableView: tableView)
    }
}

//MARK: - 未配载，显示配载的情况，即订单来源为 3 的情况
extension WaybillDetailBaseVC {
    
    func unAssembleSepecialToDesignateNumSection() -> Int {
        return 2
    }
    
    func unAssembleSepecialToDesignateRows(section:Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    func unAssembleSepecialToAssemble(indexPath:IndexPath , tableView:UITableView) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
            if row == 2 {
                return waybillHandleCell(tableView: tableView, handleName: "配载")
            }
        }
        return waybillGoodsInfoCell(tableView: tableView)
    }
}


//MARK: - 未完成，待起运的cell配置
extension WaybillDetailBaseVC {
    
    func notDoneWillStartNumSection() -> Int {
        return 3
    }
    
    func notDoneWillStartRow(section:Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func notDoneWillStartCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
        }
        if  section == 1  {
            return  waybillDealInfoCell(tableView: tableView)
        }
        return waybillGoodsInfoCell(tableView: tableView)
    }
}


//MARK: - 未完成，运输中的cell配置
extension WaybillDetailBaseVC {
    func notDoneTransportingNumSection() -> Int {
        return 4
    }
    
    func notDoneTransportingRow(section:Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func notDoneTransportingCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
        }
        if  section == 1  {
            return  waybillDealInfoCell(tableView: tableView)
        }
        if section == 2 {
            return waybillGoodsInfoCell(tableView: tableView)
        }
        return waybillReturnListCell(tableView: tableView, canEdit: true)
    }
}


//MARK: - 未完成，待签收的cell配置
extension WaybillDetailBaseVC {
    func notDoneWillSignNumSection() -> Int {
        return 4
    }
    
    func notDoneWillSignRow(section:Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func notDoneWillSignCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
        }
        if  section == 1  {
            return  waybillDealInfoCell(tableView: tableView)
        }
        if section == 2 {
            return waybillGoodsInfoCell(tableView: tableView)
        }
        return waybillReturnListCell(tableView: tableView, canEdit: true)
    }
}


//MARK: - 未完成，待办单的cell配置
extension WaybillDetailBaseVC {
    func notDoneNotStartNumSection() -> Int {
        return 3
    }
    
    func notDoneNotStartRow(section:Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    func notDoneNotStartCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
            if row == 2 {
                return waybillHandleCell(tableView: tableView, handleName: "修改配载")
            }
        }
        if  section == 1  {
            return  waybillDealInfoCell(tableView: tableView)
        }
        return waybillGoodsInfoCell(tableView: tableView)
    }
}


//MARK: - 已完成，一个评价 / 互评
extension WaybillDetailBaseVC {
    func doneCommentedtNumSection() -> Int {
        return 5
    }
    
    func doneCommentedRows(section:Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func doneCommentedCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
        }
        if section == 1 {
            return waybillDealInfoCell(tableView: tableView)
        }
        if section == 2 {
            return waybillGoodsInfoCell(tableView: tableView)
        }
        if section == 3 {
            return waybillReturnListCell(tableView: tableView, canEdit: false)
        }
        if currentDisplayMode == .done_commentOne {
            return waybillOneCommentCell(tableView: tableView)
        }
        return waybillCommentAllCell(tableView: tableView)
    }
    
    
    // 一个评价时 的展示
    func doneOneCommentCell(tableView:UITableView) -> UITableViewCell {
        return waybillOneCommentCell(tableView:tableView)
    }
    
    // 互评的 展示
    func doneAllCommentCell(tableView:UITableView) -> UITableViewCell {
        return waybillCommentAllCell(tableView:tableView)
    }
}

//MARK: - 已完成，待评价的展示
extension WaybillDetailBaseVC {
    func doneToCommentNumSection() -> Int {
        return 2
    }
    
    func doneToCommentRow(section:Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func doneToCommentCell(tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return waybillStatusCell(tableView: tableView)
            }
            if row == 1 {
                return waybillLinkInfoCell(tableView: tableView)
            }
        }
        return waybillToCommentCell(tableView: tableView)
    }
}

//MARK: - 获取运单详情
extension WaybillDetailBaseVC {
    
    func loadDetailData(transportNo:String) -> Void {
        self.showLoading()
        BaseApi.request(target: API.queryTransportDetail(transportNo), type: BaseResponseModel<TransactionInformation>.self)
            .subscribe(onNext: { [weak self](data) in
                self?.hiddenToast()
                self?.currrentEvaluatedStatus(info: data.data)
                self?.showCurrentPageInfo(info: data.data)
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
    
    //MARK: - Evaluated
    // 签收状态下，根据 返回的数据 ， 判断当前的评价状态
    func currrentEvaluatedStatus(info:TransactionInformation?) {
        let evaluatedList = info?.evaluateList
        let myComment = self.myComment(evaluteList: evaluatedList)
        let commetMe = self.commentToMe(evaluteList: evaluatedList)
        if myComment != nil && commetMe != nil { // 互评
            self.currentDisplayMode = .done_commentAll
        }
        if myComment != nil && commetMe == nil { // 我已评价
            self.currentDisplayMode = .done_commentOne
        }
        
        if myComment == nil && commetMe != nil {
            self.currentDisplayMode = .done_commentOne
        }
    }
    
    // 获取我评价别人
    func myComment(evaluteList:[ZbnEvaluate]?) -> ZbnEvaluate? {
        var evaluted:ZbnEvaluate? = nil
        if let evaluteList = evaluteList {
            let filterEvaluate = evaluteList.filter { (value) -> Bool in
                return value.evaluateTo == 1 || value.evaluateTo == 2
            }
            if filterEvaluate.count > 0 {
                evaluted = filterEvaluate.first
            }
        }
        return evaluted
    }
    
    // 获取评价我的
    func commentToMe(evaluteList : [ZbnEvaluate]?) -> ZbnEvaluate? {
        var evaluted:ZbnEvaluate? = nil
        if let evaluteList = evaluteList {
            let filterEvaluate = evaluteList.filter { (value) -> Bool in
                return value.evaluateTo == 3 || value.evaluateTo == 4
            }
            if filterEvaluate.count > 0 {
                evaluted = filterEvaluate.first
            }
        }
        return evaluted
    }
}


//MARK: - event
extension WaybillDetailBaseVC {
    override func routeName(routeName: String, dataInfo: Any?) {
        if routeName == WAYBILL_HANDLE_NAME {
            self.handleAction()
        }
    }
}