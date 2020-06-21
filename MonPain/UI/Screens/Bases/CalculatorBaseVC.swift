//
//  CalculatorBaseVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 09.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit
import PersonalizedAdConsent

private enum AdType {
    case personalized
    case nonPersonalized
    case none
}

public class CalculatorBaseVC: UITableViewController {
    
    private var adManager: TableViewAdManager!
    private var adType = AdType.none
    
    public internal(set) var calculatorType: CalculatorType = .FlourAndWater
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                        
        adManager = TableViewAdManager(controller: self, tableView: self.tableView)
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topOutsideTextfield(sender:))))
        
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
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown && PACConsentInformation.sharedInstance.consentStatus == .unknown) {
            requestConsent()
        }
        else {
            self.adManager.didAppear()
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.adManager.didDisappear()
    }
    
    @objc
    private func topOutsideTextfield(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func requestConsent() {
        // TODO: Replace with your app's privacy policy url.
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
}
