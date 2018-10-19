//
//  PathDetailVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class PathDetailVC: AttentionDetailBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    public var lineHall:FollowLineOrderHallResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func pageTitle() -> String? {
        return ""
    }
}
