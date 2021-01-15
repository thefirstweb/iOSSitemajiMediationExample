//
//  ViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/15.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interstitial = createAndLoadInterstitial()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-8618425161170926/3924096662"
        bannerView.rootViewController = self
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
    }

    func createAndLoadInterstitial() -> GADInterstitial {
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-8618425161170926/5791889714")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
}

extension ViewController:GADBannerViewDelegate {
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
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

extension ViewController:GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}

extension ViewController:GADCustomEventInterstitialDelegate {
    func requestAd(withParameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        print("request")
//          interstitial = SampleInterstitial()
//          interstitial.delegate = self
//          interstitial.adUnit = serverParameter
//          let adRequest = SampleAdRequest()
//          adRequest.testMode = request.isTesting
//          adRequest.keywords = request.userKeywords
//          interstitial.fetchAd(adRequest)
    }
    
    func present(fromRootViewController rootViewController: UIViewController) {
        print("present")
//        if interstitial.interstitialLoaded {
//            interstitial.show()
//          }
    }
    
    func customEventInterstitialDidReceiveAd(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialDidReceiveAd")
    }
    
    func customEventInterstitial(_ customEvent: GADCustomEventInterstitial, didFailAd error: Error?) {
        print("customEventInterstitial")
    }
    
    func customEventInterstitialWasClicked(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialWasClicked")
    }
    
    func customEventInterstitialDidDismiss(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialDidDismiss")
    }
    
    func customEventInterstitialWillPresent(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialWillPresent")
    }
    
    func customEventInterstitialWillDismiss(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialWillDismiss")
    }
    
    func customEventInterstitialWillLeaveApplication(_ customEvent: GADCustomEventInterstitial) {
        print("customEventInterstitialWillLeaveApplication")
    }
    
    func customEventInterstitial(_ customEvent: GADCustomEventInterstitial, didReceiveAd ad: NSObject) {
        print("customEventInterstitial")
    }
}

class CustomInterstitial: NSObject,GADCustomEventInterstitial {
    var delegate: GADCustomEventInterstitialDelegate?
    
    required override init() {
        super.init()
    }
    
    func requestAd(withParameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        print("paramater:\(serverParameter) label:\(serverLabel)")
    }
    
    func present(fromRootViewController rootViewController: UIViewController) {
        print("present")
    }
}
