//
//  AboutZbnVC.swift
//  WDL_CYR
//
//  Created by yaya on 2018/11/5.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class AboutZbnVC: NormalBaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于织布鸟"
       
        let webView = UIWebView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: self.view.frame.size.height)))
        self.view .addSubview(webView)
        let urlString = HOST + "/app/common/companyProfile"
//        let urlString = "http://172.16.59.47:8081/zbn-web/app/common/companyProfile"
        webView.loadRequest(URLRequest.init(url: URL.init(string: urlString)!))
        webView.delegate = self

    }
   
}


// MARK: - UIWebViewDelegate
extension AboutZbnVC: UIWebViewDelegate {
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }

    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }

    // 该方法是在UIWebView请求失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       self.showFail(fail: "加载失败", complete: nil)

    }
}

