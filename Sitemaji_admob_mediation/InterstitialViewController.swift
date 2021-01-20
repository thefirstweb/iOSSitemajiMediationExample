//
//  InterstitialViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/19.
//

import UIKit
import GoogleMobileAds

class InterstitialViewController: UIViewController {
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    var textField:UITextView!
    var logView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "蓋版廣告"
        
        createUI()
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        
        textField = UITextView.init(frame: CGRect.init(x: 20, y: 120, width: self.view.frame.size.width - 40, height: 40))
        textField.backgroundColor = UIColor.gray
        textField.text = "ca-app-pub-8618425161170926/5791889714"
        
        let button = UIButton.init(frame: CGRect.init(x: 20, y: textField.frame.maxY + 20, width: self.view.frame.size.width - 40, height: 40))
        button.setTitle("Show AD", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        logView = UITextView.init(frame: CGRect.init(x: 0, y: button.frame.maxY + 20, width: self.view.frame.size.width, height: self.view.frame.size.height - button.frame.maxY - 20))
        logView.backgroundColor = UIColor.darkGray
        logView.font = UIFont.systemFont(ofSize: 16)
        logView.textColor = UIColor.white
        logView.isEditable = false
        
        self.view.addSubview(textField)
        self.view.addSubview(button)
        self.view.addSubview(logView)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: textField.text ?? "")
        interstitial.delegate = self
        let request = GADRequest()
        let extras = GADCustomEventExtras()
        extras.setExtras(["SampleExtra": true], forLabel: "CustomInterstitial")
        request.register(extras)
        interstitial.load(request)
        return interstitial
    }
    
    @objc func buttonClick() {
        showLog(msg: "ad will fetch")
        interstitial = createAndLoadInterstitial()
    }
    
    func showLog(msg:String) {
        logView.text.append("\(msg) \r\n")
    }
}

extension InterstitialViewController:GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        showLog(msg:"interstitialDidReceiveAd")
        if interstitial.isReady {
            logView.text.append("interstitialDidReceiveAd")
            interstitial.present(fromRootViewController: self)
        }
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        showLog(msg:"interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        showLog(msg:"interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        showLog(msg:"interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        showLog(msg:"interstitialDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
        showLog(msg:"interstitialWillLeaveApplication")
    }
}

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
    
    //廣告關閉按鈕被點擊時，此為optional
//    func adCloseClick() {
//        print("ad close")
//        adView.removeFromSuperview()
//    }
}

//extension CustomInterstitial:GADCustomEventInterstitialDelegate {
//    func customEventInterstitialDidReceiveAd(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialDidReceiveAd")
//    }
//
//    func customEventInterstitial(_ customEvent: GADCustomEventInterstitial, didFailAd error: Error?) {
//        print("customEventInterstitial")
//    }
//
//    func customEventInterstitialWasClicked(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialWasClicked")
//    }
//
//    func customEventInterstitialDidDismiss(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialDidDismiss")
//    }
//
//    func customEventInterstitialWillPresent(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialWillPresent")
//    }
//
//    func customEventInterstitialWillDismiss(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialWillDismiss")
//    }
//
//    func customEventInterstitialWillLeaveApplication(_ customEvent: GADCustomEventInterstitial) {
//        print("customEventInterstitialWillLeaveApplication")
//    }
//
//    func customEventInterstitial(_ customEvent: GADCustomEventInterstitial, didReceiveAd ad: NSObject) {
//        print("customEventInterstitial")
//    }
//}
