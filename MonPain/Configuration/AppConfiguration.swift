//
//  AppConfiguration.swift
//  MonPain
//
//  Created by Jonathan Duss on 24.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation
import os.log

class AppConfiguration {
    
    public static let shared: AppConfiguration = AppConfiguration()
    
    public init() {
        self.appOpenings += 1
    }
    
    // MARK: - Interstiatial ads management
    
    private let numberOpeningsKey = "numberOpeningsKey"
    
    private var userDefault: UserDefaults { return UserDefaults.standard }
    
    public var appOpenings: Int {
        get {
            userDefault.integer(forKey: numberOpeningsKey)
        }
        set {
            userDefault.setValue(newValue, forKey: numberOpeningsKey)
        }
    }
    
    // MARK: - Ads configuration
    #if LITE
    
    private let showAdsAfterOpenings = 5
    private var adDisplayed = false
    
    public func shouldDisplayAd()  -> Bool {
        guard adDisplayed != true else { return false}
        
        let shouldDisplayAd = (appOpenings >= showAdsAfterOpenings) && (appOpenings % showAdsAfterOpenings == 0)
        
        if shouldDisplayAd {
            adDisplayed = true
            return true
        }
        
        OSLog.log(message: "should ? \(shouldDisplayAd) (number of openings: \(appOpenings)")
        return shouldDisplayAd
    }
    
    #endif
    
}
