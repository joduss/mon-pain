//
//  AdvertisedViewController.swift
//  MonPain
//
//  Created by Jonathan Duss on 23.09.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


#if LITE
import UserMessagingPlatform
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds

public class AdvertisedViewController: UIViewController {
    
    @IBOutlet public var adContainerView: UIView?
    
    private var adsManager: AdsManager?
    private var interstitial: GADInterstitial?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        #if DEBUG
        UMPConsentInformation.sharedInstance.reset()
        #endif
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestConfigureAdsManager()
        requestConsentInfoUpdate()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.adsManager?.stopDisplayingAds()
    }
    
    // MARK: - Admob management

    /// To override to configure the ads manager
    open func configureAdsManager() -> AdsManager? { return nil }
    
    public func displayInterstitial(adUnitID: String) {
        interstitial = GADInterstitial(adUnitID: adUnitID)
        let request = GADRequest()
        interstitial!.load(request)
        
        tryDisplayInterstitial()
    }
    
    public func tryDisplayInterstitial(attempts: Int = 0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(1000)) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if attempts > 10 {
                return
            }
            
            if strongSelf.interstitial!.isReady {
                strongSelf.interstitial?.present(fromRootViewController: strongSelf)
            }
            else {
                self?.tryDisplayInterstitial(attempts: attempts + 1)
            }
        }
    }
    
    // MARK: - Admob
    
    private func requestConfigureAdsManager() {
        if adsManager == nil {
            adsManager = configureAdsManager()
            if adsManager == nil {
                print("AdsManager is not configured.")
            }
        }
        else {
            adsManager?.canDisplayAds()
        }
    }
    
    private func requestConsentInfoUpdate() {
        
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        
        #if DEBUG
//            let debugSettings = UMPDebugSettings()
//            debugSettings.geography = .EEA
//            parameters.debugSettings = debugSettings
//            debugSettings.testDeviceIdentifiers = ["402098E9-BD47-48F4-A948-A35B3F76D644" ];
        #endif
        
        UMPConsentInformation.sharedInstance
            .requestConsentInfoUpdate(with: parameters) {
                (_ error: Error?) -> Void in
                if error != nil {
                    // Consent info update failed.
                } else {
                    // Consent info update succeeded. The shared PACConsentInformation
                    // instance has been updated.
                    let status = UMPConsentInformation.sharedInstance.formStatus
                    
                    if (status == .unavailable) {
                        self.adsManager?.canDisplayAds()
                    }
                    else {
                        self.loadContentForm()
                    }
                }
            }
    }
    
    private func loadContentForm() {
        UMPConsentForm.load() {
            (form, loadError) in
            if (loadError != nil) {
                // Handle the error
            } else {
                // Present the form. You can also hold on to the reference to present
                // later.
                let consentStatus = UMPConsentInformation.sharedInstance.consentStatus
                
                if consentStatus == .required {
                    form?.present(from: self, completionHandler: {dismissError in
                        if (UMPConsentInformation.sharedInstance.consentStatus ==
                                .obtained) {
                            // App can start requesting ads.
                            self.adsManager?.canDisplayAds()
                        }
                    })
                }
                else if consentStatus == .obtained || consentStatus == .notRequired {
                    self.adsManager?.canDisplayAds()
                }
            }
        }
    }
    
    
}

#else
@objcMembers
public class AdvertisedViewController: UIViewController {
    @IBOutlet public var adContainerView: UIView?
}
#endif
