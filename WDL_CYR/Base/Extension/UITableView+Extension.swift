//
//  UITableView+Extension.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/18.
//  Copyright © 2018年 yinli. All rights reserved.
//

import Foundation


extension UITableView {
    
    // 注册xib cell
    func registerCell<T:UITableViewCell>(nib:T.Type){
        self.register(UINib(nibName: "\(nib)", bundle: nil), forCellReuseIdentifier: "\(nib)")
    }
    
    // 注册 cell
    func registerCell<T:UITableViewCell>(className:T.Type) -> Void {
        self.register(className, forCellReuseIdentifier: "\(className)")
    }
    
    // 注册 header footer
    func registerHeaderFooter<T:UITableViewCell>(nib:T.Type) -> Void {
        self.register(UINib(nibName: "\(nib)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(nib)")
    }
    
    // 获取xib cell
    func dequeueReusableCell<T:UITableViewCell>(nib:T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(nib)") as! T
    }
    
    func dequeueReusableHeaderFooter<T:UITableViewHeaderFooterView>(nib:T.Type) -> T? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(nib)") as? T
    }
    
    func dequeueReusableCell<T:UITableViewCell>(className:T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(className)") as! T
    }
    
    func initDisplay() -> Void {
        self.tableFooterView = UIView()
    }
}
