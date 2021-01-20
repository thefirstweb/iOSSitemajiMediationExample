//
//  CustomBannerViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/20.
//

import Foundation
import GoogleMobileAds

class CustomBannerViewController: NSObject,GADCustomEventBanner {
    var delegate: GADCustomEventBannerDelegate?
    var url:String?
    var adVC:UIViewController?
    
    required override init() {
        super.init()
    }
    
    func requestAd(_ adSize: GADAdSize, parameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        print("paramater:\(serverParameter) label:\(serverLabel)")
        self.url = serverParameter
        guard let url = self.url else {
            self.delegate?.customEventBanner(self, didFailAd: nil)
            return
        }
        
//        let adView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 100))
//        adView.backgroundColor = UIColor.yellow
//        self.delegate?.customEventBanner(self, didReceiveAd: adView)
        
        //show webView ad
        //336x280廣告
        //廣告view預定放置位置及大小
        let adViewFrame:CGRect = CGRect.init(x: 0, y: 0, width: 320, height: 50)
        var adView:UIView = UIView()
        adView.frame = adViewFrame
        //handle ad delegate
        let adManager = SMJWebADHandler.sharedInstance
        adManager.delegate = self
        //產生336x280廣告
        adView = adManager.adView(adUrl: url,frame: adViewFrame)
        self.delegate?.customEventBanner(self, didReceiveAd: adView)
    }
    
    @objc func closeButtonDidClick() {
        self.delegate?.customEventBannerWillDismissModal(self)
        adVC?.dismiss(animated: true, completion: {
            [weak self] in
            self?.delegate?.customEventBannerDidDismissModal(self as! GADCustomEventBanner)
        })
    }
    
    //取得最上層的viewController
    func getTopViewController() -> UIViewController{
        return self.topViewControllerWithRootViewController(rootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
    //取得最上層的viewController
    func topViewControllerWithRootViewController(rootViewController:UIViewController) -> UIViewController{
        if rootViewController.isKind(of: UITabBarController.classForCoder()){
            let tabBarController:UITabBarController = rootViewController as! UITabBarController
            return self.topViewControllerWithRootViewController(rootViewController:tabBarController.selectedViewController!)
        }else if rootViewController.isKind(of: UINavigationController.classForCoder()){
            let navigationController:UINavigationController = rootViewController as! UINavigationController
            return self.topViewControllerWithRootViewController(rootViewController:navigationController.visibleViewController!)
        }else{
            return rootViewController
        }
    }
}

//實作廣告delegate
extension CustomBannerViewController:SMJWebADHandlerDelegate {
    //點擊廣告時callback
    func adDidClick() {
        print("ad did click")
        //可以在這裡關閉廣告
        self.delegate?.customEventBannerWillLeaveApplication(self)
        self.delegate?.customEventBannerWasClicked(self)
    }
    //廣告讀取有問題時callback
    func adFetchError(errorMsg: String) {
        print("error:\(errorMsg)")
//        adVC?.dismiss(animated: false, completion: nil)
        self.delegate?.customEventBanner(self, didFailAd: nil)
    }
    
    func adFetchSuccess() {
        print("banner success")
//        self.delegate?.customEventBanner(self, didReceiveAd: <#T##UIView#>)
    }
    
    func showLog(msg:String) {
//        logView.text.append("\(msg) \r\n")
        print(msg)
    }
}

extension CustomBannerViewController: GADCustomEventBannerDelegate {
    func customEventBanner(_ customEvent: GADCustomEventBanner, didReceiveAd view: UIView) {
        showLog(msg: "didReceiveAd")
    }
    
    func customEventBanner(_ customEvent: GADCustomEventBanner, didFailAd error: Error?) {
        showLog(msg: "didFailAd")
    }
    
    func customEventBannerWasClicked(_ customEvent: GADCustomEventBanner) {
        showLog(msg: "customEventBannerWasClicked")
    }
    
    var viewControllerForPresentingModalView: UIViewController {
        showLog(msg: "viewControllerForPresentingModalView")
        
        return self.getTopViewController()
    }
    
    func customEventBannerWillPresentModal(_ customEvent: GADCustomEventBanner) {
        showLog(msg: "customEventBannerWillPresentModal")
    }
    
    func customEventBannerWillDismissModal(_ customEvent: GADCustomEventBanner) {
        showLog(msg: "customEventBannerWillDismissModal")
    }
    
    func customEventBannerDidDismissModal(_ customEvent: GADCustomEventBanner) {
        showLog(msg: "customEventBannerDidDismissModal")
    }
    
    func customEventBannerWillLeaveApplication(_ customEvent: GADCustomEventBanner) {
        showLog(msg: "customEventBannerWillLeaveApplication")
    }
    
    func customEventBanner(_ customEvent: GADCustomEventBanner, clickDidOccurInAd view: UIView) {
        showLog(msg: "clickDidOccurInAd")
    }
}
