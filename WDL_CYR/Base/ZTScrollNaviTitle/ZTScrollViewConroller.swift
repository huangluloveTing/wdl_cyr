//
//  ZTScrollViewConroller.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ZTScrollViewConroller: UIViewController {
    
    private var subItems:[ZTScrollItem]?
    private var naviSelectView:ZTScrollNaviBarView?
    
    private var isTapTab:Bool? = false // 判断当前操作是点击导航栏上的tabIndex  还是滑动
    
    //MARK: 设置子视图
    func scrollSubItems(items:[ZTScrollItem]) -> Void {
        self.subItems = items
        self.collectionView.reloadData()
        self.configNaviSelectTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(self.collectionView)
        self.addNaviSelectView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let flowlayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.itemSize = self.view.bounds.size
        self.collectionView.collectionViewLayout = flowlayout
        self.collectionView.frame = self.view.bounds
    }
    
    //MARK: collectionView
    private lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "\(ZTScrollItemCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ZTScrollItemCell.self)")
        return collectionView
    }()
    
    func setTitleTintColor(color:UIColor , state:UIControlState) -> Void {
        self.naviSelectView?.setHeaderTintColor(color: color, state: state)
    }
}

extension ZTScrollViewConroller : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subItems?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:    IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ZTScrollItemCell.self)", for: indexPath) as! ZTScrollItemCell
        
        let contentView = cell.vcContentView
        let item = self.subItems![indexPath.row]
        let vc = item.viewController as? UIViewController
        if vc != nil {
            contentView?.addSubview((vc?.view)!)
            vc?.view.frame = (contentView?.bounds)!
            self.addChildViewController(vc!)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if self.isTapTab == true {
                return
            }
            let offset = scrollView.contentOffset.x
            let index = round(offset / scrollView.zt_width)
            self.naviSelectView?.toSelected(index: Int(index))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTapTab = false
    }
}

// navi titles
extension ZTScrollViewConroller {
    private func addNaviSelectView() {
        let naviTitle = ZTScrollNaviBarView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH - 120, height: 44))
        self.naviSelectView = naviTitle
        self.naviSelectView?.tapClosure = { (index) in
            self.isTapTab = true
            self.scrollCollectionView(index: index)
        }
        self.navigationItem.titleView = naviTitle
    }
    
    private func configNaviSelectTitle() {
        let titles = self.subItems?.map({ (item) -> String in
            return item.title
        })
        self.naviSelectView?.updateTitles(titles: titles!)
    }
}

// scroll
extension ZTScrollViewConroller {
    
    private func scrollCollectionView(index:Int) {
        let offset = CGPoint(x: CGFloat(index) * self.collectionView.zt_width, y: 0)
        self.collectionView.setContentOffset(offset, animated: true)
    }
    
    
}
