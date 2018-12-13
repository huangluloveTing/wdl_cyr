//
//  MoreScreenSelectionVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/12/12.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class MoreScreenSelectionVC: NormalBaseVC {
    
    public var currentSelectionItems:[MoreScreenSelectionItem] = []
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    @IBAction func resetHandle(_ sender: Any) {
        resetMoreItems()
    }
    
    @IBAction func sureHandle(_ sender: Any) {
        callBackForRefresh(param: currentSelectionItems)
        self.pop()
    }
}

extension MoreScreenSelectionVC {
    
    //MARK: - config tableView
    func initTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nib: MoreScreenCell.self)
        tableView.registerCell(nib: MoreInputCell.self)
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 10)
        tableView.separatorColor = UIColor(hex: "F0F0F0")
    }
}

extension MoreScreenSelectionVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = currentSelectionItems[indexPath.row]
        if item.type == .multiSelect {
            let cell = tableView.dequeueReusableCell(nib: MoreScreenCell.self)
            cell.showCurrentItems(items: item.items, item.title)
            cell.selectClosure = {[weak self](currentCell , index) in
                self?.tapSelect(cell: currentCell, index: index)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(nib: MoreInputCell.self)
            cell.showInput(title: item.title, input: item.inputItem?.input, placeholder: item.inputItem?.placeholder) { (text) in
                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSelectionItems.count
    }
}

extension MoreScreenSelectionVC {
    //MARK: - 点击筛选的数据操作
    private func tapSelect(cell:BaseCell , index:Int) -> Void {
        let indexPath = self.tableView.indexPath(for: cell)
        if let indexpath = indexPath {
            tapItemHandle(indexPath: indexpath , tapIndex: index)
        }
    }
    
    //MARK: - 根据点击的，改变对应 item 的展示
    private func tapItemHandle(indexPath:IndexPath , tapIndex index:Int) -> Void {
        
        let selectItem = selectItemHandle(item: currentSelectionItems[indexPath.row], index: index)
        currentSelectionItems[indexPath.row] = selectItem
        self.tableView.reloadData()
    }
    
    //MARK: - 选择相关的逻辑
    //如果title 为 不限 则 其他 不选择 ，
    // 选择其他 ， 不限就需要 不选中
    private func selectItemHandle(item:MoreScreenSelectionItem , index:Int) -> MoreScreenSelectionItem {
        var newItems = item.items
        if newItems[index].title == "不限" {
            return clickNolimitHandle(index: index, item: item)
        } else {
            return clickNotNolimitHandle(index: index, item: item)
        }
    }
    
    //MARK: - 选择的不是 不限 选项 ，需要将 不限设置为不选中
    func clickNotNolimitHandle(index:Int , item:MoreScreenSelectionItem) -> MoreScreenSelectionItem {
        var subItem = item.items[index]
        if subItem.title != "不限" {
            subItem.select = !subItem.select
        }
        //需要将不限设置为非选中
        var newItems = item.items.map { (enum_item) -> MoreScreenItem in
            var newItem = enum_item
            if newItem.title == "不限" {
                newItem.select = false
            }
            return newItem
        }
        newItems[index] = subItem
        var newItem = item
        newItem.items = newItems
        return newItem
    }
    
    //MARK: - z选择的是 不限 选项，需要将 其他所有设置为 不选中
    func clickNolimitHandle(index:Int , item:MoreScreenSelectionItem) -> MoreScreenSelectionItem {
        var subItem = item.items[index]
        if subItem.title == "不限" {
            subItem.select = true;
        }
        //需要将不限设置为非选中
        var newItems = item.items.map { (enum_item) -> MoreScreenItem in
            var newItem = enum_item
            newItem.select = false
            return newItem
        }
        newItems[index] = subItem
        var newItem = item
        newItem.items = newItems
        return newItem
    }
}

extension MoreScreenSelectionVC {
    //MARK: - 重置操作
    private func resetMoreItems() -> Void {
        let items = currentSelectionItems.enumerated().map { (offset ,item) -> MoreScreenSelectionItem in
            var newItem = item
            if newItem.type == .input {
                var inputItem = newItem.inputItem
                inputItem?.input = ""
                newItem.inputItem = inputItem
                return newItem
            }
            else {
                let items = newItem.items.enumerated().map({ (offset , subItem) -> MoreScreenItem in
                    var newSubItem = subItem
                    if offset == 0 {
                        newSubItem.select = true
                    } else {
                        newSubItem.select = false
                    }
                    return newSubItem
                })
                newItem.items = items
                return newItem
            }
        }
        
        currentSelectionItems = items
        self.tableView.reloadData()
    }
}
