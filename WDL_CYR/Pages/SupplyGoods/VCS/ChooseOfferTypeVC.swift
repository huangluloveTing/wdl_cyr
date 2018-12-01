//
//  ChooseOfferTypeVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

enum OfferMethodMode { // 报价方式
    case truck      // 有车报价
    case noTruck    // 无车报价
    case all        // 都可以
}

class ChooseOfferTypeVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var resource : ResourceDetailUIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubViews()
    }
    
    override func callBackForRefresh(param: Any?) {
        if let callBack = self.callBack {
            callBack(.refresh(param))
        }
    }
}

//MARK: views
extension ChooseOfferTypeVC {
    func configSubViews() -> Void {
        self.tableView.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
}

extension ChooseOfferTypeVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentOfferMethod() {
        case .all:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        switch currentOfferMethod() {
        case .all:
            if indexPath.row == 0 {
                cell?.textLabel?.text = "有车报价"
            } else {
                cell?.textLabel?.text = "无车报价"
            }
            break
        case .truck:
            cell?.textLabel?.text = "有车报价"
            break
        default:
            cell?.textLabel?.text = "无车报价"
        }
        
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch currentOfferMethod() {
        case .all:
            if row == 0 {
                /// 有车报价
                let offerTruckVC = OfferWithTruckVC()
                offerTruckVC.resource = self.resource
                self.pushToVC(vc: offerTruckVC, title: "报价")
                return
            }
            //无车报价
            let offerNoTruckVC = OfferNoTruckVC()
            offerNoTruckVC.resource = self.resource
            self.pushToVC(vc: offerNoTruckVC, title: "报价")
            break
        case .truck:
            /// 有车报价
            let offerTruckVC = OfferWithTruckVC()
            offerTruckVC.resource = self.resource
            self.pushToVC(vc: offerTruckVC, title: "报价")
            break
        default:
            //无车报价
            let offerNoTruckVC = OfferNoTruckVC()
            offerNoTruckVC.resource = self.resource
            self.pushToVC(vc: offerNoTruckVC, title: "报价")
        }
       
    }
}


extension ChooseOfferTypeVC {
    
    // 来做 tms 的 d货源，如果是 指定了 报价方式，则只能对应的报价方式进行报价
    // sourceType : 1:来至ZBN，2:来至TMS , 3:来自SAP ,
    // 当前的 报价方式 offerWay 报价方式[1：有车报价 2：无车报价] ,
    func currentOfferMethod() -> OfferMethodMode {
        if self.resource?.resource?.sourceType == 2 {
            if self.resource?.resource?.offerWay == 1 {
                return .truck
            }
            if self.resource?.resource?.offerWay == 2 {
                return .noTruck
            }
        }
        return .all
    }
}
