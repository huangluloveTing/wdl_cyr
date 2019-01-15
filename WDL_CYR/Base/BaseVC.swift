//
//  BaseVC.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/23.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift


//MARK: - 页面返回回调的mode
enum CallbackMode {
    case refresh(Any?)
    case other(Any)
}

// 页面操作  -> tableView 的相关操作

typealias HandleExcute<T> = (T) -> ()
typealias HandleError = (Error) -> ()
typealias HandleComplete = () -> ()

class BaseVC: UIViewController {
    
    public var callBack:((CallbackMode) -> ())?
    
    public let dispose = DisposeBag()
    
    public var naviTitleView = ZTScrollNaviBarView(frame: CGRect(x: 60 * IPHONE_RATE, y: 0, width: IPHONE_WIDTH - 60 * IPHONE_RATE * 2, height: 44))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
//        self.registerMessageNotification()
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.currentConfig()
        self.bindViewModel()
        self.configNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 页面配置，针对当前页面配置，只需重写
    func currentConfig()  {
        
    }
    
    // 绑定vm
    func bindViewModel() {
        
    }
    
    // MARK: 导航栏的操作
    override func zt_rightBarButtonAction(_ sender: UIBarButtonItem!) {
        
    }
    
    override func zt_leftBarButtonAction(_ sender: UIBarButtonItem!) {
        self.pop()
    }
    
    // 搜索框的当前的输入内容回调，可重写
    func searchBarInput(search:String) -> Void {
        print("current search content : " + search)
    }
    
    //MARK: - callBack
    // 页面返回回调的刷新
    func callBackForRefresh(param:Any?) -> Void {
        if let callBack = self.callBack {
            callBack(.refresh(param))
        }
    }
    
    // 页面返回回调的其他操作
    func callBackForOtherHandle(param:Any?) -> Void {
        
    }
    
    //MARK: - 消息接受 回调
    func receiveMessageResultHandler() -> Void {
        
    }
}

// 跳转新页面
extension BaseVC {
    
    // 跳转新页面（当需要页面回调时，使用这个跳转方法，并在页面需要回调时，调用回调 闭包）
    func pushToVC(vc:BaseVC , title:String?) -> Void {
        vc.callBack = {[weak self] (model) in
            switch model {
            case .refresh(let param):
                self?.callBackForRefresh(param: param)
                break
            case .other(let param):
                self?.callBackForOtherHandle(param: param)
                break
            }
        }
        self.push(vc: vc, title: title)
    }
}


// 搜索及消息
extension BaseVC {
    
    // 添加头部搜索条
    func addNaviHeader(placeholer:String = "搜索我的运单(运单号、承运人、车牌号、线路)") {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH - 70, height: 44))
        let searchBar = MySearchBar(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH - 70, height: 44))
        searchBar.contentInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
        searchBar.barStyle = UIBarStyle.default
        searchBar.rx.text.orEmpty
            .skip(1)
            .share(replay: 1)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](text) in
                self?.searchBarInput(search: text)
            })
            .disposed(by: dispose)
        contentView.addSubview(searchBar)
        searchBar.placeholder = placeholer
        contentView.backgroundColor = UIColor.clear
        self.navigationItem.titleView = contentView
    }
    
    // 添加头部信息
    func addMessageRihgtItem() {
        let rightBadgeView = BageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        rightBadgeView.bgImage(image: #imageLiteral(resourceName: "message"))
        rightBadgeView.badgeValue(text: "99")
        rightBadgeView.textFont()
        rightBadgeView.badgeColor(color: UIColor.white)
        rightBadgeView.bgColor(bgColor: UIColor.clear)
        self.addRightBarbuttonItem(with: rightBadgeView)
    }
    
    // 添加下拉展开视图
    /**
     * drop 添加的下拉视图
     * anchorView 锚点视图 -- 确定下拉视图的位置和大小
     */
    func addDropView(drop:UIView,anchorView:UIView) -> DropViewContainer {
        return DropViewContainer(dropView: drop, anchorView: anchorView)
    }
    
}

// navigationBar
extension BaseVC {
    private func configNavigationBar() {
        self.backBarButtonItem()
    }
}


// 处理tableView
extension BaseVC {
    
    // 注册cell
    func registerCell(nibName:String , for tableView:UITableView) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerForNibCell<T:UITableViewCell>(className: T.Type, for tableView:UITableView) {
        tableView.register(UINib(nibName: "\(className)", bundle: nil), forCellReuseIdentifier: "\(className)")
    }
    
    //注册 header footer
    func registerHeaderFooterForNib<T:UITableViewHeaderFooterView>(className:T.Type , for tableView:UITableView) -> Void {
        tableView.register(UINib(nibName: "\(className)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(className)")
    }
    
    // 获取注册的cell
    func dequeueReusableCell<T:UITableViewCell>(className:T.Type , for tableView:UITableView) -> T {
        return tableView.dequeueReusableCell(withIdentifier: "\(className)") as! T
    }
    
    // 获取注册的 header footer
    func dequeueReusableHeaderFooter<T:UITableViewHeaderFooterView>(className:T.Type , for tableView:UITableView) -> T {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(className)") as! T
    }
    
    // 隐藏tableViewCell分割线
    func hiddenTableViewSeperate(tableView:UITableView) {
        tableView.separatorStyle = .none
    }
    
    // 分割线贯通
    func fullSeperate(for tableView:UITableView) -> Void {
        var insets = tableView.separatorInset
        insets.right -= insets.right
        insets.left -= insets.left
        tableView.separatorInset = insets
    }
    
    // 获取xib视图
    func loadNibView<T:UIView>(nibName:T.Type) -> T {
        let view = Bundle.main.loadNibNamed("\(nibName)", owner: nil, options: nil)?.first as! T
        return view
    }
}

// 处理 observable
extension BaseVC {
    
    func addObservable<T>(observable:Observable<T> ,
                          handleExcute:HandleExcute<T>? = nil ,
                       handError:HandleError? = nil ,
                       handleComplete:HandleComplete? = nil) {
        observable.subscribe(onNext: { (excute) in
                if  let handleExcute = handleExcute {
                    handleExcute(excute)
                }
            }, onError: { (error) in
                if let handleError = handError {
                    handleError(error)
                }
            }, onCompleted: {
                if let handleComplete = handleComplete {
                    handleComplete()
                }
            })
            .disposed(by: dispose)
    }
}

// 添加 searchBar 到 tableView 上
extension BaseVC : UISearchBarDelegate {
    
    func addSearchBar(to tableView:UITableView , placeHolder:String? = "搜索驾驶员姓名、电话") -> Void {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: -40, width: IPHONE_WIDTH, height: 40))
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor(hex: TEXTCOLOR_EMPTY)
        searchBar.placeholder = placeHolder
        tableView.addSubview(searchBar)
        searchBar.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(searchBar.frame)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(searchBar.frame)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.frame)
    }
}

// 添加导航栏上面的 选项卡
extension BaseVC {
    //添加顶部的tab事件
    func addNaviSelectTitles(titles:[String]) {
       
        
//        let naviTitle = ZTScrollNaviBarView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH - 120, height: 44))
//         let naviTitle = ZTScrollNaviBarView(frame: CGRect(x: 60 * IPHONE_RATE, y: 0, width: IPHONE_WIDTH - 60 * IPHONE_RATE * 2, height: 44))
        self.naviTitleView.backgroundColor = UIColor.clear
        
        self.naviTitleView.updateTitles(titles: titles)
        self.naviTitleView.tapClosure = { [weak self](index) in
            self?.tapNaviHandler(index: index)
        }
        self.navigationController?.navigationBar.addSubview(self.naviTitleView)
      
//        self.navigationItem.titleView = naviTitle
    }
    
     func removeNaviTitle() {
        self.naviTitleView.removeFromSuperview()
    }
    
    
    @objc func tapNaviHandler(index:Int) -> Void {
        
    }
}

extension BaseVC {
    //MARK: 配置省市区
    func initialPlace() -> Observable<[PlaceChooiceItem]> {
        let observable = Observable<[PlaceChooiceItem]>.create { (obser) -> Disposable in
            let areas = Util.configServerRegions(regions: WDLCoreManager.shared().regionAreas ?? [])
            obser.onNext(areas)
            obser.onCompleted()
            return Disposables.create()
        }
        return observable
    }
}

// navigation item
extension BaseVC {
    // 删除左边的item
    func removeRightBarButton() -> Void {
        self.addLeftBarbuttonItem(with: UIView(frame: .zero))
    }
}

// 调用图片浏览器
extension BaseVC {
    func showLocalImags(imgs:[UIImage] , imageSuperView:UIView) -> Void {
        PictureBroweManager.shard().showPictures(imgItems: imgs, imageSuperView: imageSuperView)
    }
    func showWebImages(imgs:[String] ,imageSuperView:UIView) -> Void {
        PictureBroweManager.shard().showWebPictures(webItems: imgs, imageSuperView: imageSuperView)
    }
}

extension BaseVC {
    func registerMessageNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessegeHandler), name: .init(PUSH_MESSAGE_VALUE), object: nil)
    }
    
    @objc private func receiveMessegeHandler() {
        receiveMessageResultHandler()
    }
}

