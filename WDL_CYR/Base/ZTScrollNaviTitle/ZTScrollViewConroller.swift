//
//  ZTScrollViewConroller.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/14.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class ZTScrollViewConroller: BaseVC {
    
    private var subItems:[ZTScrollItem]?
//    private var naviSelectView:ZTScrollNaviBarView?
    
    private var currentFrontView:ZTScrollViewControllerType?
    
    private var isTapTab:Bool? = false // 判断当前操作是点击导航栏上的tabIndex  还是滑动
    
    //MARK: 设置子视图
    func scrollSubItems(items:[ZTScrollItem]) -> Void {
        self.subItems = items
        self.currentFrontView = items.first?.viewController
        self.addAllSubVC()
        self.collectionView.reloadData()
        self.configNaviSelectTitle()
    }
    
    //MARK: - 添加首所有的子视图控制器
    func addAllSubVC() -> Void {
        self.subItems?.forEach({ (item) in
            if let vc = item.viewController as? UIViewController {
                self.addChildViewController(vc)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(self.collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.addNaviSelectView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.naviSelectView.removeFromSuperview()
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
        collectionView.isScrollEnabled = self.horiScrolEnable()
        collectionView.register(UINib.init(nibName: "\(ZTScrollItemCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ZTScrollItemCell.self)")
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    private lazy var naviSelectView :ZTScrollNaviBarView = {
        let naviTitle = ZTScrollNaviBarView()
        naviTitle.tapClosure = { (index) in
            self.isTapTab = true
            self.scrollCollectionView(index: index)
        }
        return naviTitle
    }()
    
    func setTitleTintColor(color:UIColor , state:UIControlState) -> Void {
        self.naviSelectView.setHeaderTintColor(color: color, state: state)
    }
    
    //MARK: - 是否启用横向滚动
    func horiScrolEnable() -> Bool {
        return true
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
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        decideCurrentFront(index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let offset = scrollView.contentOffset.x
            let index = round(offset / scrollView.zt_width)
            if self.isTapTab == true {
                return
            }
            self.naviSelectView.toSelected(index: Int(index))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTapTab = false
    }
    
    //MARK: - 获取当前显示的vc
    func decideCurrentFront(index:Int) -> Void {
        let front = self.subItems![index]
        if self.currentFrontView == nil {
            self.currentFrontView = front.viewController
            self.currentFrontView?.didShow()
            return
        }
        if (self.currentFrontView! as! UIViewController) != (front.viewController as! UIViewController) {
            self.currentFrontView?.willDisappear()
            self.currentFrontView = front.viewController
            self.currentFrontView?.didShow()
        }
    }
}

// navi titles
extension ZTScrollViewConroller {
    private func addNaviSelectView() {
        self.naviSelectView.frame = CGRect(x: 60 * IPHONE_RATE, y: 0, width: IPHONE_WIDTH - 60 * IPHONE_RATE * 2, height: 44)
        
        self.navigationController?.navigationBar.addSubview(self.naviSelectView)
//        self.navigationItem.titleView = self.naviSelectView
    }
    
    private func configNaviSelectTitle() {
        let titles = self.subItems?.map({ (item) -> String in
            return item.title
        })
        self.naviSelectView.updateTitles(titles: titles!)
    }
}

// scroll
extension ZTScrollViewConroller {
    
    private func scrollCollectionView(index:Int) {
//        let offset = CGPoint(x: CGFloat(index) * self.collectionView.zt_width, y: 0)
        self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
}
