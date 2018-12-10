//
//  AboutZbnVC.swift
//  WDL_CYR
//
//  Created by yaya on 2018/11/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import SnapKit

class AboutZbnVC: NormalBaseVC {
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let webView = UIWebView()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(0)
        }
      
        webView.loadRequest(URLRequest.init(url: URL.init(string: urlString ?? "")!))
        webView.delegate = self

    }
    
    
    deinit {
        self.hiddenToast()
    }
   
}


// MARK: - UIWebViewDelegate
extension AboutZbnVC: UIWebViewDelegate {
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showLoading()
    }

    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hiddenToast()
    }

    // 该方法是在UIWebView请求失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       self.showFail(fail: "加载失败", complete: nil)
    }
}

