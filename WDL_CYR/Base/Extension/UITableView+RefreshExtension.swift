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
            objc_setAssociatedObject(self, &refreshKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    
    func beginRefresh() -> Void {
        if let header = self.mj_header {
            header.beginRefreshing()
        }
    }
    
    func beginLoadMore() -> Void {
        if let footer = self.mj_footer {
            footer.beginRefreshing()
        }
    }
    
    //MARK: - 初始化 tableView 的 预估高度，防止 上拉加载时出现的无限加载
    func initEstmatedHeights() -> Void {
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
    }
    
    //MARK: -
    func refreshAndLoadState() -> Observable<TableViewState> {
        return self.refreshState.asObserver().distinctUntilChanged()
            .throttle(2, scheduler: MainScheduler.instance)
            .filter({ (state) -> Bool in
                return state != .EndRefresh
            })
    }
    
    func tableResultHandle(currentListCount:Int? , total:Int?) -> Void {
        if (currentListCount ?? 0) >= (total ?? 0) {
            self.noMore()
        }
    }
}

extension Reactive where Base : UITableView {
   
    var refresh:Binder<TableViewState> {
        return Binder.init(self.base, binding: { (tableView, state) in
            
        })
    }
}
