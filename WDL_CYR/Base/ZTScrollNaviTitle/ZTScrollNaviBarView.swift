//
//  ZTScrollNaviBarView.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ZTScrollNaviBarView: UIView {

    typealias ZTNaviScrollClosure = (Int) -> ()
    
    private var titleItems:[String]?
    
    public var tapClosure:ZTNaviScrollClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleView:HTHorizontalSelectionList = {
       let hotiView = HTHorizontalSelectionList(frame: self.bounds)
        hotiView.delegate = self
        hotiView.centerButtons = true
        hotiView.selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationMode.heavyBounce
        hotiView.showsEdgeFadeEffect = true
        hotiView.setTitleColor(UIColor(hex: COLOR_BUTTON), for: .selected)
        hotiView.setTitleColor(UIColor(hex: TEXTFIELD_TITLECOLOR), for: .normal)
        hotiView.setTitleFont(UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), for: .normal)
        hotiView.setTitleFont(UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), for: .selected)
        hotiView.selectionIndicatorHeight = 3
        hotiView.selectionIndicatorColor = UIColor(hex: COLOR_BUTTON)
        hotiView.bottomTrimHidden = true
        hotiView.delegate = self
        hotiView.dataSource = self
        return hotiView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleView.frame = self.bounds
    }
}


//MARK: Public method
extension ZTScrollNaviBarView {
    func updateTitles(titles:[String]) -> Void {
        self.titleItems = titles
        self.titleView.reloadData()
    }
    
    func toSelected(index:Int) {
        self.titleView.setSelectedButtonIndex(index, animated: true)
    }
}

extension ZTScrollNaviBarView : HTHorizontalSelectionListDelegate , HTHorizontalSelectionListDataSource {
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        if let closure = self.tapClosure {
            closure(index)
        }
    }
    
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        return self.titleItems?.count ?? 0
    }
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        return self.titleItems![index]
    }
    
}
