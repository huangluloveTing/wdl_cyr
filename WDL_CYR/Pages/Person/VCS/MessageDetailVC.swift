//
//  MessageDetailVC.swift
//  WDL_TYR
//
//  Created by Apple on 2018/11/20.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class MessageDetailVC: NormalBaseVC {
    //参数
    private var queryBean : MessageQueryBean = MessageQueryBean()
    //数组
//    private var hallLists:[MessageQueryBean] = []
    //用户信息
    private var zbnConsignor:ZbnCarrierInfo?
    //当前消息类型
    public var currentMsgType:Int?
    //当前消息的信息
    public var currentInfo:MessageQueryBean?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取用户信息
        self.zbnConsignor = WDLCoreManager.shared().userInfo
        configTableView()
    }
}

//MARK: - config
extension MessageDetailVC {
    func configTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        self.registerCell(nibName: "\(MessageDetailCell.self)", for: tableView)
        self.registerCell(nibName: "\(MessageDetailAcceptCell.self)", for: tableView)//报价信息
        tableView.tableFooterView = UIView()
    }
}



//MARK: - UITableViewDelegate , UITableViewDataSource
extension MessageDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //报价或系统cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageDetailCell.self)") as! MessageDetailCell
        
        //运单信息cell才有接受和拒绝
        let wayCell = tableView.dequeueReusableCell(withIdentifier: "\(MessageDetailAcceptCell.self)") as! MessageDetailAcceptCell
       
    
        let info = self.currentInfo
        var title:String? = ""
       
        if info?.msgType == 1 { //系统消息
            title = "系统消息"
        }
        if info?.msgType == 2 { //报价消息
            title = "报价消息"
         
        }
        if info?.msgType == 3 { // 运单信息
            title = "运单信息"
            if self.currentInfo?.msgStatus == 2 ||  self.currentInfo?.msgStatus == 3 {
                wayCell.acceptBtn.isHidden = true
                wayCell.refuseBtn.isHidden = true
                wayCell.accHeightConstant.constant = 0
                wayCell.refHeightConstant.constant = 0
            }else{
                wayCell.acceptBtn.isHidden = false
                wayCell.refuseBtn.isHidden = false
                wayCell.accHeightConstant.constant = 30
                wayCell.refHeightConstant.constant = 30
                
            }
            wayCell.showDetalMessageInfo(title: title ?? "", content: info?.msgInfo, time: info?.createTime)
            self.quoteBtnClick(cell: wayCell)
            return wayCell
        }
       //报价或系统cell，只读
        cell.showDetalMessageInfo(title: title ?? "", content: info?.msgInfo, time: info?.createTime)
        
     
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}

//MARK:运单信息逻辑处理
extension MessageDetailVC{
    
    
    func  quoteBtnClick(cell: MessageDetailAcceptCell) {
        //cell按钮点击跳转事件
        
        cell.buttonClosure = { [weak self] (sender) in
            if sender.tag == 44 {
                //拒绝
                guard var info = self?.currentInfo else {
                    self?.showFail(fail: "没有获取到消息数据", complete: nil)
                    return
                }
                info.msgStatus = 3
                self?.markMessegeRequest(model: info)
            }else {
                //接受
                guard var info = self?.currentInfo else {
                    self?.showFail(fail: "没有获取到消息数据", complete: nil)
                    return
                }
                info.msgStatus = 2
                self?.markMessegeRequest(model: info)
            
            }
            
        
            
            //跳转运单页面
            let tab =  UIApplication.shared.keyWindow?.rootViewController as! RootTabBarVC
            self?.pop(toRootViewControllerAnimation: false)
            tab.selectedIndex = 2
            
        }
        
    }
    
    
    //接受或拒绝（0：未读， 1=已读 2=接受 3=拒绝）
    func markMessegeRequest(model: MessageQueryBean){
        
        BaseApi.request(target: API.markHasSeenMessage(model),  type: BaseResponseModel<AnyObject>.self)
            .subscribe(onNext: { (_) in
                print("接受和拒绝成功")
            }, onError: { (error) in
                //                self.showFail(fail: error.localizedDescription, complete: nil)
                
            })
            .disposed(by: dispose)
    }
  
    
   
   
    
}
