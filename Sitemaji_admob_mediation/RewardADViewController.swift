//
//  RewardADViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/3/23.
//

import UIKit
import GoogleMobileAds

class RewardADViewController: UIViewController {
    var rewardedAd: GADRewardedAd?
    var textField:UITextView!
    var logView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI() {
        self.view.backgroundColor = UIColor.white
        
        textField = UITextView.init(frame: CGRect.init(x: 20, y: 120, width: self.view.frame.size.width - 40, height: 40))
        textField.backgroundColor = UIColor.gray
        textField.text = "ca-app-pub-8618425161170926/6823649837"
        
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
//        showLog(msg: "ad will fetch")
        rewardedAd = createAndLoadRewardedAd(adUnitId:textField.text)
        
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print("Loading failed: \(error)")
                self.showLog(msg: "Loading failed: \(error)")
            } else {
                print("Loading Succeeded")
                self.showLog(msg: "Loading Succeeded")
                self.showAd()
            }
          }
    }
    
    func createAndLoadRewardedAd(adUnitId:String) -> GADRewardedAd {
        showLog(msg: "Rewarded ad will generate")
        var genRewardedAd = GADRewardedAd(adUnitID: adUnitId)
        showLog(msg: "Rewarded ad did generate")
        return genRewardedAd
    }
    
    func showLog(msg:String) {
        logView.text.append("\(msg) \r\n")
    }
}

extension RewardADViewController: GADRewardedAdDelegate {
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        showLog(msg: "Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
        showLog(msg: "Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        showLog(msg: "Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
        showLog(msg: "Rewarded ad failed to present.")
    }
    
    func showAd() {
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
            showLog(msg: "Rewarded ad did display")
        }else{
            showLog(msg: "Rewarded ad not ready")
        }
    }
}
