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
    //如果选择的是第一个，即不限的情况，如果选中时，别的都未非选中
    // 不是第一个时 ，要将不限设置为非选中
    private func selectItemHandle(item:MoreScreenSelectionItem , index:Int) -> MoreScreenSelectionItem {
        var newItem = item
        var newItems = item.items
        if index == 0 { //
            let selectItem = item.items[index]
            if selectItem.select == false {
                newItems = item.items.enumerated().map({ (offset , ite) -> MoreScreenItem in
                    var newIt = ite
                    if offset == 0 {
                        newIt.select = true
                    }
                    else {
                        newIt.select = false
                    }
                    return newIt
                })
            }
        } else {
            newItems = item.items.enumerated().map({ (offset , ite) -> MoreScreenItem in
                var newIt = ite
                if offset == 0 {
                    newIt.select = false
                }
                if offset == index  {
                    newIt.select = !newIt.select
                }
                
                return newIt
            })
        }
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
