//
//  OfferChooseDriverVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/22.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class OfferChooseDriverVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }
    
}

// config
extension OfferChooseDriverVC {
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCell(nib: ChooseDriverCell.self)
    }
}

extension OfferChooseDriverVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(nib: ChooseDriverCell.self)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}
