//
//  CalculatorBaseVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 09.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

#if LITE
import PersonalizedAdConsent
#endif

private enum AdType {
    case personalized
    case nonPersonalized
    case none
}

public class CalculatorBaseVC: UITableViewController {
    
    #if LITE
    private var adManager: TableViewAdManager!
    private var adType = AdType.none
    #endif
    
    public internal(set) var calculatorType: CalculatorType = .FlourAndWater
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topOutsideTextfield(sender:))))
        
        #if DEBUG
//        PACConsentInformation.sharedInstance.debugGeography = .EEA;
        #endif
        
        #if LITE
            adManager = TableViewAdManager(controller: self, tableView: self.tableView)
            
            PACConsentInformation.sharedInstance.requestConsentInfoUpdate(forPublisherIdentifiers: [AdsConfiguration.publisherId]) {
                (_ error: Error?) -> Void in
                if error != nil {
                    // Consent info update failed.
                    self.adType = .none
                } else {
                    // Consent info update succeeded. The shared PACConsentInformation
                    // instance has been updated.
                    let status = PACConsentInformation.sharedInstance.consentStatus
                    
                    if (status == .personalized) {
                        self.adType = .personalized
                        self.adManager.personalized = true
                    }
                    else {
                        self.adType = .nonPersonalized
                        self.adManager.personalized = false
                    }
                }
            }
        #endif
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if LITE
        if (PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown && PACConsentInformation.sharedInstance.consentStatus == .unknown) {
            requestConsent()
        }
        else {
            self.adManager.didAppear()
        }
        #endif
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if LITE
        self.adManager.didDisappear()
        #endif
    }
    
    @objc
    private func topOutsideTextfield(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    #if LITE
    private func requestConsent() {
        guard let privacyUrl = URL(string: "http://theuselessapp.epizy.com/"),
            let form = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl) else {
                print("incorrect privacy URL.")
                return
        }
        form.shouldOfferPersonalizedAds = true
        form.shouldOfferNonPersonalizedAds = true
        
        form.load {(_ error: Error?) -> Void in
            print("Load complete.")
            if let error = error {
                // Handle error.
                print("Error loading form: \(error.localizedDescription)")
                self.adType = .none
            } else {
                // Load successful.
                form.present(from: self) { (error, userPrefersAdFree) in
                    if error != nil {
                        // Handle error.
                        self.adType = .none
                    }
                    else {
                        // Check the user's consent choice.
                        let status = PACConsentInformation.sharedInstance.consentStatus

                        if (status == .personalized) {
                            self.adType = .personalized
                            self.adManager.personalized = true
                        }
                        else {
                            self.adType = .nonPersonalized
                            self.adManager.personalized = false
                        }
                        
                        self.adManager.didAppear()
                    }
                }
            }
        }
    }
    #endif
}
