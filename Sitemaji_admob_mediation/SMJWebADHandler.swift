//
//  SMJWebADHandler.swift
//  TestWebAD
//
//  Created by Alex on 2018/11/23.
//  Copyright © 2018年 Feebee. All rights reserved.
//

import Foundation
import WebKit

@objc protocol SMJWebADHandlerDelegate: NSObjectProtocol {
    func adFetchError(errorMsg:String)
    func adDidClick()
    @objc optional func adCloseClick()
}

@objc class SMJWebADHandler:NSObject {
    @objc var delegate:SMJWebADHandlerDelegate?
    
    @objc public class var sharedInstance : SMJWebADHandler {
        struct Static {
            static let instance : SMJWebADHandler = SMJWebADHandler()
        }
        
        return Static.instance
    }
}

@objc extension SMJWebADHandler:WKUIDelegate {
    /**
    - Parameters:
        - adUrl: 廣告網址。
        - frame: 廣告大小。
        - isShowCloseButton: 是否顯示關閉按鈕，預設為false。
    */
    @objc func adView(adUrl:String,frame:CGRect = CGRect.zero,isShowCloseButton:Bool = false) -> UIView {
        
        let containView = UIView()
        let adWebView:WKWebView = WKWebView()
        adWebView.frame = frame
        adWebView.uiDelegate = self
        adWebView.navigationDelegate = self
        adWebView.allowsBackForwardNavigationGestures = false
        adWebView.scrollView.isScrollEnabled = false
        
        if #available(iOS 11.0, *) {
            adWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        
        if let url = URL.init(string: adUrl) {
            let request = URLRequest.init(url: url)
            adWebView.load(request)
        }else{
            self.delegate?.adFetchError(errorMsg: "fetch url error")
        }
        
        containView.addSubview(adWebView)
        
        if isShowCloseButton {
            let closeBanner = UIButton()
            closeBanner.frame = CGRect.init(x: 0, y: adWebView.frame.maxY, width: frame.size.width, height: 40)
            closeBanner.setTitle("close", for: .normal)
            closeBanner.backgroundColor = .gray
            closeBanner.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
            containView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height+40)
            containView.addSubview(closeBanner)
        }else{
            containView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        }
        
        return containView
    }
    
    private func closeButtonClick() {
        self.delegate?.adCloseClick?()
    }
}

//MARK:- WKNavigationDelegate
extension SMJWebADHandler:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //        print(error.localizedDescription)
        self.delegate?.adFetchError(errorMsg: "error.localizedDescription")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //blankNothing
        if let isMainFrame = navigationAction.targetFrame?.isMainFrame {
            if (!isMainFrame) {
                webView.load(navigationAction.request)
            }
        }else{
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            self.delegate?.adDidClick()
            if let url = navigationAction.request.url {
                UIApplication.shared.openURL(url)
            }
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}
