//
//  FocusResourceVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum FocusResourceDisplay {
    case focusPerson    // 关注托运人
    case focusLines     // 关注线路
}

class FocusResourceVC: MainBaseVC , ZTScrollViewControllerType {
    
    
    @IBOutlet weak var focusPersonBtn: UIButton!
    @IBOutlet weak var focusLinesBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentTopIndex:Int = 0
    
    private var displayType:FocusResourceDisplay = .focusPerson

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.toTapHeader(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func currentConfig() {
        
    }
    
    //MARK:
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    //MARK: 切换
    @IBAction func focusPersonAction(_ sender: UIButton) {
        self.toTapHeader(index: 0)
        self.tableView.reloadData()
    }
    @IBAction func focusLineAction(_ sender: UIButton) {
        self.toTapHeader(index: 1)
        self.tableView.reloadData()
    }
    
    func registerAllCells() {
        self.registerCell(nibName: "\(FocusPersonCell.self)", for: self.tableView)
        self.registerCell(nibName: "\(FocusLinesCell.self)", for: self.tableView)
    }
    
    func configTableView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        self.registerAllCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
}

extension FocusResourceVC { // 关注托运人或者关注线路 切换
    
    func currentDisplayContentType() -> FocusResourceDisplay {
        if self.currentTopIndex == 0 {
            return .focusPerson
        }
        return .focusLines
    }
    
    func toTapHeader(index:Int) -> Void {
        self.currentTopIndex = index
        if index == 0 {
            self.focusPersonBtn.isSelected = true
            self.focusLinesBtn.isSelected = false
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        else {
            self.focusPersonBtn.isSelected = false
            self.focusLinesBtn.isSelected = true
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
    }
    
}

extension FocusResourceVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayType = self.currentDisplayContentType()
        if displayType == .focusPerson {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FocusPersonCell.self)") as! FocusPersonCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FocusLinesCell.self)") as! FocusLinesCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension FocusResourceVC { // EmptyDatasource
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed("\(FocusEmptyView.self)", owner: nil, options: nil)?.first as! FocusEmptyView
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
