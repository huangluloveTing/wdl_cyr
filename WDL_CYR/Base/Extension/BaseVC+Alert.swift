//
//  BaseVC+Alert.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/11.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

enum AlertVCMode {
    case alert
    case sheet
}

extension BaseVC {
    
    public func showAlert(title:String? = "" , message:String? = "", closure:((Int) -> ())? = { (index) in }) {
        showAlert(items: ["取消","确定"], title: title, message: message, showCancel: false, closure:closure , mode: .alert)
    }
    
    
    public func showAlert(items:[String], title:String? = "提示" , message:String? = nil , showCancel:Bool = true , closure:((Int)->())? = nil ,mode:AlertVCMode = .alert) {
        let alertVC = UIAlertController(title:title , message: message, preferredStyle: mode == .alert ? .alert : .actionSheet)
        items.enumerated().forEach { (index ,item) in
            let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                if let closure = closure {
                    closure(index)
                }
            })
            alertVC.addAction(action)
        }
        
        if showCancel == true {
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
                let index = items.count
                if let closure = closure {
                    closure(index)
                }
            }
            alertVC.addAction(cancelAction)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}
