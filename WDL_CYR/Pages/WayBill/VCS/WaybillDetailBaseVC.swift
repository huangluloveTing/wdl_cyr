//
//  WaybillDetailBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/8.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - config tableView
extension WaybillDetailBaseVC {
    
    func configTableView(tableView:UITableView) -> Void {
        currentTableView = tableView
        currentTableView?.delegate = self
        currentTableView?.dataSource = self
        currentTableView?.separatorColor = UIColor(hex: " ")
        registerAllCells()
    }
    
    func registerAllCells() -> Void {
        currentTableView?.registerCell(nib: WayBillDetailStatusCell.self)
        currentTableView?.registerCell(nib: WaybillLinkInfoCell.self)
        currentTableView?.registerCell(nib: WaybillGoodsInfoCell.self)
        currentTableView?.registerCell(nib: WaybillDealInfoCell.self)
        currentTableView?.registerCell(nib: WaybillHandleCell.self)
        currentTableView?.registerCell(nib: WaybillReturnListCell.self)
        currentTableView?.registerCell(nib: WayBillToCommentCell.self)
        currentTableView?.registerCell(nib: WayBillCommentAllCell.self)
        currentTableView?.registerCell(nib: WayBillOneCommentCell.self)
    }
    
    //MARK: - 配置当前页面的展示模式
    func currentShowMode(mode:WaybillDisplayMode) -> Void {
        currentDisplayMode = mode
    }
    
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
        return cell
    }
    //MARK: - 联系人信息的cell
    func waybillLinkInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillLinkInfoCell.self)
        
        return cell
    }
    //MARK: - 指派，配载等操作d相关的cell
    func waybillHandleCell(tableView:UITableView , handleName:String?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillHandleCell.self)
        
        return cell
    }
    
    //MARK: - 成交信息相关的cell
    func waybillDealInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillDealInfoCell.self)
        return cell
    }
    
    //MARK: - 货源信息相关e的cell
    func waybillGoodsInfoCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillGoodsInfoCell.self)
        return cell
    }
    
    //MARK: - 运单回单的相关功能
    func waybillReturnListCell(tableView:UITableView , canEdit:Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WaybillReturnListCell.self)
        return cell
    }
    
    //MARK: - 未评价，评价运单的cell
    func waybillToCommentCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillToCommentCell.self)
        return cell
    }
    
    //MARK: - 已完成，展示一个评价信息的cell
    func waybillOneCommentCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillOneCommentCell.self)
        return cell
    }
    
    //MAKR: - 已完成，展示互评的cell
    func waybillCommentAllCell(tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: WayBillCommentAllCell.self)
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
