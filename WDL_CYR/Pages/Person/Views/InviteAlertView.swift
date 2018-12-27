//
//  InviteAlertView.swift
//  WDL_TYR
//
//  Created by Apple on 2018/11/28.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class InviteAlertView: UIView {
    
    //提示框视图
    
    @IBOutlet weak var alertView: UIView!
    //复制的内容
    @IBOutlet weak var contentLabel: UILabel!
    //复制按钮
    @IBOutlet weak var copyButton: UIButton!
    
    
    static func showInviteAlertView() {
        let view = Bundle.main.loadNibNamed("InviteAlertView", owner: nil, options: nil)?.first as? InviteAlertView
        view?.showOnWindow()
    }
    
    private func showOnWindow() {
        let window = UIApplication.shared.keyWindow
        self.frame = (window?.bounds)!
        window?.addSubview(self)
    }
//    override init(frame:CGRect){
//        super.init(frame: frame)
//        self.alertView.addBorder(color:nil, width: 0, radius: 10)
//        self.copyButton.addBorder(color:nil, width: 0, radius: 4)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAlertView))
//        self.addGestureRecognizer(tap)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
    
    //关闭
    @IBAction func closeBtn(_ sender: UIButton) {
        self.hiddenAlertView()
    }
    //隐藏视图
    @objc private func hiddenAlertView(){
        self.removeFromSuperview()
    }
    
    //复制
    @IBAction func copyBtn(_ sender: UIButton) {
        /*
         NSString * str = @"https://itunes.apple.com/cn/app/idxxxxx?mt=8";
         NSURL *url = [NSURL URLWithString:str];
         [[UIApplication sharedApplication] openURL:url];
         */
        
        UIPasteboard.general.string = "我在织布鸟邀请你作为驾驶员！快来注册吧！"
        SVProgressHUD.showSuccess(withStatus: "复制成功")
        SVProgressHUD.dismiss(withDelay: 1.0)
        
        self.hiddenAlertView()
    }
 
    override func draw(_ rect: CGRect) {

        self.alertView.addBorder(color:nil, width: 0, radius: 10)
        self.copyButton.addBorder(color:nil, width: 0, radius: 4)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAlertView))
        self.addGestureRecognizer(tap)

    }
 

}