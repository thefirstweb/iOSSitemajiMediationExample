//
//  CustomInterstitial.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/3/24.
//

import UIKit
import GoogleMobileAds

class CustomInterstitial: NSObject,GADCustomEventInterstitial {
    var delegate: GADCustomEventInterstitialDelegate?
    var url:String?
    var adVC:UIViewController?
    
    required override init() {
        super.init()
    }
    
    func requestAd(withParameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        print("paramater:\(serverParameter) label:\(serverLabel)")
        self.url = serverParameter
        guard let url = self.url else {
            self.delegate?.customEventInterstitial(self, didFailAd: nil)
            return
        }
        
        //init custom intersitial
        self.delegate?.customEventInterstitialDidReceiveAd(self)
//        self.delegate?.customEventInterstitial(self, didFailAd: nil)
    }
    
    func present(fromRootViewController rootViewController: UIViewController) {
        print("present")
        guard let adUrl = self.url else { return }
        self.delegate?.customEventInterstitialWillPresent(self)
        
        adVC = UIViewController.init()
        adVC?.modalPresentationStyle = .currentContext
        adVC?.modalTransitionStyle = .crossDissolve
        adVC?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        //show webView ad
        //336x280廣告
        //廣告view預定放置位置及大小
        let adViewFrame:CGRect = CGRect.init(x: 0, y: 0, width: 320, height: 480)
        var adView:UIView = UIView()
        adView.frame = adViewFrame
        //handle ad delegate
        let adManager = SMJWebADHandler.sharedInstance
        adManager.delegate = self
        //產生336x280廣告
        adView = adManager.adView(adUrl: adUrl,frame: adViewFrame)
        //可自行決定廣告要放在哪
        adView.center = adVC?.view.center ?? CGPoint.init(x: 0, y: 0)
        
        let closeButton = UIButton.init(frame: CGRect.init(x: adView.frame.maxX - 20, y: adView.frame.origin.y - 20, width: 40, height: 40))
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.backgroundColor = UIColor.white
        closeButton.layer.cornerRadius = 20
        closeButton.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        
        //把廣告加到畫面中
        adVC?.view.addSubview(adView)
        adVC?.view.addSubview(closeButton)
        
        guard let vc = adVC else { return }
        self.getTopViewController().present(vc, animated: true, completion: {
            [weak self] in
            
        })
    }
    
    @objc func closeButtonDidClick() {
        self.delegate?.customEventInterstitialWillDismiss(self)
        adVC?.dismiss(animated: true, completion: {
            [weak self] in
            self?.delegate?.customEventInterstitialDidDismiss(self as! GADCustomEventInterstitial)
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
extension CustomInterstitial:SMJWebADHandlerDelegate {
    //點擊廣告時callback
    func adDidClick() {
        print("ad did click")
        //可以在這裡關閉廣告
        self.delegate?.customEventInterstitialWillLeaveApplication(self)
        self.delegate?.customEventInterstitialWasClicked(self)
    }
    //廣告讀取有問題時callback
    func adFetchError(errorMsg: String) {
        print("error:\(errorMsg)")
        adVC?.dismiss(animated: false, completion: nil)
        self.delegate?.customEventInterstitial(self, didFailAd: nil)
    }
    
    func adFetchSuccess() {
        self.delegate?.customEventInterstitialDidReceiveAd(self)
    }
}
