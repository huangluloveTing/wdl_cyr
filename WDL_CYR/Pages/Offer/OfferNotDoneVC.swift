//
//  OfferNotDoneVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferNotDoneVC: MainBaseVC , ZTScrollViewControllerType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropHintView: DropHintView!
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configDropView()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// tableView
extension OfferNotDoneVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.registerCell(nibName: "\(Offer_NotDoneCell.self)", for: self.tableView)
    }
}

// UITableViewDelegate , UITableViewDataSource
extension OfferNotDoneVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Offer_NotDoneCell.self)") as! Offer_NotDoneCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.shadowBorder(radius: 10, bgColor: UIColor.white, shadowColor: UIColor(hex: "C9C9C9"), shadowOpacity: 0.5, insets: UIEdgeInsetsMake(15, 15, 0, 15))
    }
    
}

// dropView
extension OfferNotDoneVC : DropHintViewDataSource {
    
    func configDropView() -> Void {
        self.dropHintView.dataSource = self
        self.dropHintView.tabTitles(titles: ["报价时间","报价状态"])
        self.dropHintView.dropTapClosure = {(index) in
            print("current tap index ： \(index)")
        }
    }
    
    func dropHintView(dropHint: DropHintView, index: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.zt_width, height: 100))
        if index == 0 {
            view.backgroundColor = UIColor.red

        } else {
            view.backgroundColor = UIColor.blue
        }
        return view
    }
}
