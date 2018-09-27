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
    
    
    @IBOutlet weak var addLinesBtn: UIButton!
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
    @IBAction func addLinesAction(_ sender: Any) {
        self.toFocusLineVC()
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
            self.addLinesBtn.isHidden = true
            self.focusPersonBtn.isSelected = true
            self.focusLinesBtn.isSelected = false
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        else {
            self.addLinesBtn.isHidden = false
            self.focusPersonBtn.isSelected = false
            self.focusLinesBtn.isSelected = true
            self.focusLinesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.focusPersonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        self.tableView.reloadEmptyDataSet()
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
        let type = self.currentDisplayContentType()
        if type == .focusLines {
            return 0
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FocusResourceVC { // EmptyDatasource
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed("\(FocusEmptyView.self)", owner: nil, options: nil)?.first as! FocusEmptyView
        let type = self.currentDisplayContentType()
        if type == .focusPerson {
            view.empty(title: "你还没有关注任何托运人", desc: "赶紧去找找感兴趣的托运人吧", buttonTitle: "添加关注托运人")
        }
        else {
            view.empty(title: "你还没有关注任何路线", desc: "赶紧去找找感兴趣的路线吧", buttonTitle: "添加关注线路")
        }
        // 自定义的view 的高度为0，需要加上高度约束
        view.snp.makeConstraints { [weak self](maker) in
            maker.height.equalTo((self?.tableView.zt_height)!)
        }
        view.tapClosure = { () in
            print("tap button")
        }
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
