//
//  OfferWithTruckVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/11.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

/// 有车报价
class OfferWithTruckVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension OfferWithTruckVC {
    //MARK: configTableView
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension OfferWithTruckVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(nib: OfferInputCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}
