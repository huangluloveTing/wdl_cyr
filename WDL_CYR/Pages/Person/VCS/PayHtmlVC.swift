//
//  PayHtmlVC.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/4.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class PayHtmlVC: NormalBaseVC {
    
    var htmlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
 
        let webView = UIWebView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: IPHONE_WIDTH, height:self.view.frame.size.height)))
        self.view.addSubview(webView)
        webView.loadHTMLString(htmlString ?? "", baseURL: nil)
        webView.delegate = self
    }

   

}
extension PayHtmlVC: UIWebViewDelegate{
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("开始加载")
        
        SVProgressHUD .show()
    }
    
    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // 该方法是在UIWebView请求失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
        self.showFail(fail: error.localizedDescription, complete: nil)
    }
    
    
    
}
