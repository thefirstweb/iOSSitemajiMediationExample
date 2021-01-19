//
//  BannerViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/19.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController {
    var bannerView: GADBannerView!
    var textField:UITextView!
    var logView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        createUI()
    }
    
    func createUI() {
        textField = UITextView.init(frame: CGRect.init(x: 20, y: 120, width: self.view.frame.size.width - 40, height: 40))
        textField.backgroundColor = UIColor.gray
        textField.text = "ca-app-pub-8618425161170926/3924096662"
        
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
    
    @objc func buttonClick() {
        showLog(msg: "ad will fetch")
        bannerView.removeFromSuperview()
        
        bannerView.adUnitID = textField.text ?? ""
        bannerView.load(GADRequest())
    }
    
    func showLog(msg:String) {
        logView.text.append("\(msg) \r\n")
    }
}

extension BannerViewController:GADBannerViewDelegate {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        showLog(msg: "adViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        showLog(msg: "adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
        showLog(msg: "adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
        showLog(msg: "adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
        showLog(msg: "adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
        showLog(msg: "adViewWillLeaveApplication")
    }
}

