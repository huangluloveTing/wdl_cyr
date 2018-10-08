//
//  TransactionDetailsVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/5.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class TransactionDetailsVC: NormalBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: config tableView
extension TransactionDetailsVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerForNibCell(className: TransactionDetailsCell.self, for: self.tableView)
        self.fullSeperate(for: self.tableView)
    }
}

extension TransactionDetailsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(className: TransactionDetailsCell.self, for: tableView)
        return cell
    }
}
