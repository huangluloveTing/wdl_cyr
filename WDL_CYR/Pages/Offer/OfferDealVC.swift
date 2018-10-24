//
//  OfferDealVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/27.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferDealVC: OfferBaseVC , ZTScrollViewControllerType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropHintView: DropHintView!
    
    func willShow() {
        
    }
    
    func didShow() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defineTableView(tableView: tableView)
        self.configDropView()
        self.configTableView()
    }
    
    override func bindViewModel() {
        self.tableView.refreshState.asObservable()
            .share(replay: 1)
            .filter { (state) -> Bool in
                return state != .EndRefresh
            }
            .subscribe(onNext: { [weak self](state) in
                self?.tableView.endRefresh()
                if state == .LoadMore {
                    self?.pageSize += 20
                } else {
                    self?.pageSize = 20
                }
                self?.loadOffers()
            })
            .disposed(by: dispose)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// tableView
extension OfferDealVC {
    
    func configTableView() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.registerCell(nibName: "\(Offer_DoneCell.self)", for: self.tableView)
    }
}

extension OfferDealVC {
    // 获取报价数据
    func loadOffers() -> Void {
        self.loadOfferData(status: 1, pageSize: self.pageSize, start: nil, end: nil, dealStatus: nil) { [weak self](res, error) in
            guard let pageInfo = res else {
                self?.showFail(fail: error?.localizedDescription, complete: nil)
                return
            }
            self?.currentUIModels = self?.configNetDataToDisplay(pageInfo: pageInfo) ?? []
            self?.tableView.reloadData()
        }
    }
}

// UITableViewDelegate , UITableViewDataSource
extension OfferDealVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Offer_DoneCell.self)") as! Offer_DoneCell
        let offerModel = self.currentUIModels[indexPath.row]
        cell.showInfo(info: offerModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUIModels.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.shadowBorder(radius: 10,
                                      bgColor: UIColor.white,
                                      shadowColor: UIColor(hex: "C9C9C9"),
                                      shadowOpacity: 0.5,
                                      insets: UIEdgeInsetsMake(15, 15, 0, 15))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.toOfferDetail(index: row)
    }

}

// dropView
extension OfferDealVC : DropHintViewDataSource {
    
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
