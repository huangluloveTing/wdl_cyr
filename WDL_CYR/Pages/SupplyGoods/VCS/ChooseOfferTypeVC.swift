//
//  ChooseOfferTypeVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class ChooseOfferTypeVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var resource : ResourceDetailUIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubViews()
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
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "有车报价"
        } else {
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
        if row == 0 {
            /// 有车报价
            let offerTruckVC = OfferWithTruckVC()
            offerTruckVC.resource = self.resource
            self.push(vc: offerTruckVC, title: "报价")
            return
        }
        //无车报价
        let offerNoTruckVC = OfferNoTruckVC()
        offerNoTruckVC.resource = self.resource
        self.push(vc: offerNoTruckVC, title: "报价")
    }
}
