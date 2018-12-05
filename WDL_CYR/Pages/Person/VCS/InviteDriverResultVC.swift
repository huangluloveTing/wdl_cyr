//
//  InviteDriverResultVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/12/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class InviteDriverResultVC: NormalBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
}

extension InviteDriverResultVC {
    //MARK: -
    func configTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(className: InviteDriverCell.self)
        tableView.registerCell(className: DriverInviteFailCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

extension InviteDriverResultVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
