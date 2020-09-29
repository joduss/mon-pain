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

public class AdvertisedViewController: UIViewController {
    
    @IBOutlet public var adContainerView: UIView?
    
    public var adsManager: AdsManager?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        #if DEBUG
//        UMPConsentInformation.sharedInstance.reset()
//        PACConsentInformation.sharedInstance.debugGeography = .EEA;
        #endif
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestConfigureAdsManager()
        requestConsentInfoUpdate()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if LITE
        self.adsManager?.stopDisplayingAds()
        #endif
    }
    
    
    /// To override to configure the ads manager
    open func configureAdsManager() { }
    
    private func requestConfigureAdsManager() {
        if adsManager == nil {
            configureAdsManager()
        }
        else {
            adsManager?.canDisplayAds()
        }
    }
    
    private func requestConsentInfoUpdate() {
        
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        
        UMPConsentInformation.sharedInstance
            .requestConsentInfoUpdate(with: parameters) {
                (_ error: Error?) -> Void in
                if error != nil {
                    // Consent info update failed.
                } else {
                    // Consent info update succeeded. The shared PACConsentInformation
                    // instance has been updated.
                    let status = UMPConsentInformation.sharedInstance.formStatus
                    
                    if (status == .available) {
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
                            if #available(iOS 14, *) {
                                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                                    // Tracking authorization completed. Start loading ads here.
                                    // loadAd()
                                    self.adsManager?.canDisplayAds()
                                })
                            } else {
                                self.adsManager?.canDisplayAds()
                            }
                        }
                    })
                }
                else if consentStatus == .obtained || consentStatus == .notRequired {
                    if #available(iOS 14, *) {
                        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                            // Tracking authorization completed. Start loading ads here.
                            // loadAd()
                            self.adsManager?.canDisplayAds()
                        })
                    } else {
                        self.adsManager?.canDisplayAds()
                    }
                }
            }
        }
    }
    
    
}

#else
public class AdvertisedViewController: UIViewController { }
#endif
