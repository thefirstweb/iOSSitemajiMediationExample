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
        if let adResponseInfo = ad.responseInfo {
            showLog(msg: "response info:\(adResponseInfo)")
        }
        
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
