//
//  PaymentTypeVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

let PAYMENT_TITLES = ["微信","支付宝","银联在线支付"]
let PAYMENT_IMAGES = [#imageLiteral(resourceName: "支付方式-微信"),#imageLiteral(resourceName: "支付方式-支付宝"),#imageLiteral(resourceName: "支付方式-银联")]

class PaymentTypeVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
    }
    
    override func currentConfig() {
        self.registerCell(nibName: "\(PaymentCell.self)", for: self.tableView)
        self.registerForNibCell(className: PaymentCommitCell.self, for: self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.hiddenTableViewSeperate(tableView: self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension PaymentTypeVC : UITableViewDelegate  , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PAYMENT_IMAGES.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < PAYMENT_IMAGES.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(PaymentCell.self)") as! PaymentCell
            let image = PAYMENT_IMAGES[indexPath.row]
            let title = PAYMENT_TITLES[indexPath.row]
            cell.showInfo(image: image, title: title)
            return cell
        }
        
        let commitCell = self.dequeueReusableCell(className: PaymentCommitCell.self, for: tableView)
        return commitCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
