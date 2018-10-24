//
//  UITableView+RefreshExtension.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/29.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum TableViewState:Int {
    case Refresh
    case LoadMore
    case EndRefresh
}


var refreshKey = "refreshKey"
extension UITableView {
    
    func pullRefresh() {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() in
            DispatchQueue.main.async {
                self?.resetFooter()
                self?.refreshState.onNext(TableViewState.Refresh)
            }
        })
    }
    
    func upRefresh() {
        self.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            DispatchQueue.main.async {
                self?.refreshState.onNext(.LoadMore)
            }
        })
    }
    
    func endRefresh() {
        let header = self.mj_header
        let footer = self.mj_footer
        if let header = header {
            header.endRefreshing()
        }
        if let footer = footer {
            footer.endRefreshing()
        }
        DispatchQueue.main.async {
            self.refreshState.onNext(.EndRefresh)
        }
    }
    
    func noMore() -> Void {
        let footer = self.mj_footer
        if let footer = footer {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
    func resetFooter() -> Void {
        let footer = self.mj_footer
        if let footer = footer {
            footer.resetNoMoreData()
        }
    }
    
    private var _freshState : PublishSubject<TableViewState>? {
        set {
            objc_setAssociatedObject(self, &refreshKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &refreshKey) as? PublishSubject
        }
    }
    
    var refreshState:PublishSubject<TableViewState> {
        guard let state = self._freshState else {
            let ob = PublishSubject<TableViewState>()
            self._freshState = ob
            return self._freshState!
        }
        return state
    }
}

extension Reactive where Base : UITableView {
   
    var refresh:Binder<TableViewState> {
        return Binder.init(self.base, binding: { (tableView, state) in
            
        })
    }
}
