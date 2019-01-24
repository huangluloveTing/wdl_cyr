//
//  GSDetailBaseVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class GSDetailBaseVC: NormalBaseVC {
    
    //MARK: handles -- 待重写的方法
    func cancelOffer() -> Void {}   // 取消报价
    func toOfferAgain() -> Void {}  // 重新报价
    
    // 竞标中
    func bidding_timer() -> TimeInterval {return 0} // 竞标中的倒计时
    // 已驳回
    func rejectReason() -> String {return ""}       // 驳回原因
    // 未成交
    func notDealReason() -> String {return ""}      // 未成交原因
    
    func myOfferInfo() -> OfferInfoModel? {return nil} // 我的报价信息
    func otherOfferInfo() -> [OfferInfoModel]? {return []} //其他人的报价信息
    func goodsSupplyInfo() -> GSInfoModel? {return nil} // 货源信息
    func showMyOffer() -> Bool { return true }
    
    //

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: 根据对应的状态 获取 cells 和 cell 的数量等
    func currentSection(status:SourceStatus , for tableView:UITableView) -> Int {
        switch status {
        case .bidding:
            return self.bidding_numberSection(for: tableView)
        case .canceled:
            return self.canceled_numberSection(for: tableView)
        case .notDeal:
            return self.notDeal_numberSection(for: tableView)
        case .rejected:
            return self.reject_numberSection(for: tableView)
        case .other:
            return 0
        default:
            return 0
        }
    }
    
    func currentRows(status: SourceStatus , section:Int , for tableView:UITableView) -> Int {
        switch status {
        case .bidding:
            return self.bidding_numberRwos(at: section, for: tableView)
        case .canceled:
            return self.canceled_numberRwos(at: section, for: tableView)
        case .notDeal:
            return self.notDeal_numberRwos(at: section, for: tableView)
        case .rejected:
            return self.reject_numberRwos(at: section, for: tableView)
        case .other:
            return 0
        default:
            return 0
        }
    }
    
    func currentCell(status:SourceStatus , indexPath:IndexPath , for tableView:UITableView) -> UITableViewCell {
        switch status {
        case .bidding:
            return self.biding_cells(indexPath: indexPath, for: tableView)
        case .canceled:
            return self.canceled_cells(indexPath: indexPath, for: tableView)
        case .notDeal:
            return self.notDeal_cells(indexPath: indexPath, for: tableView)
        case .rejected:
            return self.reject_cells(indexPath: indexPath, for: tableView)
        case .other:
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
    }
    
    //MARK: 配置底部按钮
    func configBottom(status:WDLOfferDealStatus , tableView:UITableView) -> Void {
        switch status {
         case .inbinding:
            self.bidding_bottom(tableView: tableView)
            break
        case .canceled:
            self.canceled_bottom(tableView: tableView)
            break
        default:
            self.noBottom(tableView: tableView)
        }
    }
    
    //MARK: - 是否获取其他人的x报价信息
    /// - 若货源信息是由TMS经销商来源
    /// - 有明报显示 ，暗报不显示其他人的名字用“*****”价格
    /// - 若货源信息是由第三方发布的都可见
    func showOtherOfferInfo() -> Bool { return true }
}

// register cells
extension GSDetailBaseVC {
    
    func registerAllCells(tableView:UITableView) -> Void {
        self.registerCell(nibName: "\(OfferDealTimerCell.self)", for: tableView)
        self.registerCell(nibName: "\(GSDetail_OfferInfoCell.self)", for: tableView)
        self.registerCell(nibName: "\(GSDetail_GoodsInfoCell.self)", for: tableView)
        self.registerCell(nibName: "\(GSDetail_canceledOfferCell.self)", for: tableView)
        self.registerCell(nibName: "\(GSDetail_rejectCell.self)", for: tableView)
        self.registerCell(nibName: "\(GSDetail_notDealCell.self)", for: tableView)
        self.registerCell(nibName: "\(Offer_otherOffersCell.self)", for: tableView)
    }
}

// 根据对应的 货源状态 ， 添加底部按钮
extension GSDetailBaseVC {
    // 竞价中
    func bidding_bottom(tableView:UITableView) -> Void {
        self.bottomButtom(titles: ["取消报价"], targetView: tableView) {[weak self](_) in
            self?.cancelOffer()
        }
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 60))
    }
    // 已取消
    func canceled_bottom(tableView:UITableView) -> Void {
        self.bottomButtom(titles: ["重新报价"], targetView: tableView) { [weak self](_) in
            self?.toOfferAgain()
        }
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 60))
    }
    
    // 已驳回
    // 未成交
    func noBottom(tableView:UITableView) -> Void {
        self.bottomButtom(titles: [], targetView: tableView)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

// 竞价中的cell组成类型
extension GSDetailBaseVC {
    
    func bidding_numberSection(for tableView:UITableView) -> Int {
        return 3
    }
    
    func bidding_numberRwos(at section:Int , for tableView:UITableView) -> Int {
        if section == 0 {
            if self.goodsSupplyInfo()?.dealWay == 2 {
                return 0
            }
        }
        if section == 1 {
//            if showOtherOfferInfo() == true {
                return 2
//            }
        }
        return  1
    }
    
    func biding_cells(indexPath:IndexPath , for tableView:UITableView) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(OfferDealTimerCell.self)") as! OfferDealTimerCell
            cell.showCuntDownTime(time: self.bidding_timer())
            return cell
        }
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(className: Offer_otherOffersCell.self)
                cell.showOfferInfo(otherOffers: self.otherOfferInfo() ?? [])
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_OfferInfoCell.self)") as! GSDetail_OfferInfoCell
            cell.showOfferInfo(myOffer: self.myOfferInfo() ?? OfferInfoModel(), otherOffers: self.otherOfferInfo())
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_GoodsInfoCell.self)") as! GSDetail_GoodsInfoCell
        cell.showGoodsInfo(info: self.goodsSupplyInfo() ?? GSInfoModel())
        return cell
     }
}

// 已取消 的 货源 cells
extension GSDetailBaseVC {
    func canceled_numberSection(for tableView:UITableView) -> Int {
        return 3
    }
    
    func canceled_numberRwos(at section:Int , for tableView:UITableView) -> Int {
        if section == 1 && showOtherOfferInfo() == true {
            return 2
        }
        return  1
    }
    
    func canceled_cells(indexPath:IndexPath , for tableView:UITableView) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_canceledOfferCell.self)") as! GSDetail_canceledOfferCell
            
            return cell
        }
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(className: Offer_otherOffersCell.self)
                cell.showOfferInfo(otherOffers: self.otherOfferInfo() ?? [])
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_OfferInfoCell.self)") as! GSDetail_OfferInfoCell
            cell.showOfferInfo(myOffer: self.myOfferInfo() ?? OfferInfoModel(), otherOffers: self.otherOfferInfo() , showOffer: showMyOffer())
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_GoodsInfoCell.self)") as! GSDetail_GoodsInfoCell
        cell.showGoodsInfo(info: self.goodsSupplyInfo() ?? GSInfoModel())
        return cell
    }
}

// 已驳回 的 货源 的 cells
extension GSDetailBaseVC {
    func reject_numberSection(for tableView:UITableView) -> Int {
        return 3
    }
    
    func reject_numberRwos(at section:Int , for tableView:UITableView) -> Int {
        if section == 1 && showOtherOfferInfo() {
            return 2
        }
        return  1
    }
    
    func reject_cells(indexPath:IndexPath , for tableView:UITableView) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_rejectCell.self)") as! GSDetail_rejectCell
            cell.showRejectReason(reject: self.rejectReason())
            return cell
        }
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(className: Offer_otherOffersCell.self)
                cell.showOfferInfo(otherOffers: self.otherOfferInfo() ?? [])
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_OfferInfoCell.self)") as! GSDetail_OfferInfoCell
            cell.showOfferInfo(myOffer: self.myOfferInfo() ?? OfferInfoModel(), otherOffers: self.otherOfferInfo() , showOffer: showMyOffer())
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_GoodsInfoCell.self)") as! GSDetail_GoodsInfoCell
        cell.showGoodsInfo(info: self.goodsSupplyInfo() ?? GSInfoModel())
        return cell
    }
}

// 未成交 的 货源 的cells
extension GSDetailBaseVC {
    func notDeal_numberSection(for tableView:UITableView) -> Int {
        return 3
    }
    
    func notDeal_numberRwos(at section:Int , for tableView:UITableView) -> Int {
        if section == 1 && showOtherOfferInfo() == true {
            return 2
        }
        return  1
    }
    
    func notDeal_cells(indexPath:IndexPath , for tableView:UITableView) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_notDealCell.self)") as! GSDetail_notDealCell
            cell.showNotReason(reson: self.notDealReason())
            return cell
        }
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(className: Offer_otherOffersCell.self)
                cell.showOfferInfo(otherOffers: self.otherOfferInfo() ?? [])
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_OfferInfoCell.self)") as! GSDetail_OfferInfoCell
            cell.showOfferInfo(myOffer: self.myOfferInfo() ?? OfferInfoModel(), otherOffers: self.otherOfferInfo() , showOffer: showMyOffer())
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GSDetail_GoodsInfoCell.self)") as! GSDetail_GoodsInfoCell
        cell.showGoodsInfo(info: self.goodsSupplyInfo() ?? GSInfoModel())
        return cell
    }
}

//MARK: - load data
extension GSDetailBaseVC {
    
    //MARK: - 获取其他人的报价
    func loadOtherInfo(model:OfferOrderHallResultApp? , closure:(([ZbnOfferModel]? , Error?) -> ())?) -> Void {
        BaseApi.request(target: API.getOtherOfferByOrderHallId(model!), type: BaseResponseModel<PageInfo<ZbnOfferModel>>.self)//[ZbnOfferModel]
            .subscribe(onNext: { (data) in
                print("报价人信息===\(data)")
                if let closure = closure {
                    closure(data.data?.list ?? [] , nil)
                }
            }, onError: { (error) in
                if let closure = closure {
                    closure(nil , error)
                }
            })
            .disposed(by: dispose)
    }
    
    //MARK: - 取消报价
    func cancelOfferHandle(hallId:String , offerId:String) -> Void {
        self.showLoading()
        BaseApi.request(target: API.cancelOffer(hallId , offerId), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: {[weak self] (data) in
                self?.hiddenToast()
                self?.showSuccess(success: data.message, complete: {
                    self?.pop(toRootViewControllerAnimation: true)
                })
            }, onError: { [weak self](error) in
                self?.showFail(fail: error.localizedDescription, complete: nil)
            })
            .disposed(by: dispose)
    }
}
