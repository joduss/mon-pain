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
    
    init() {
        appOpenings += 1
    }
    
    // MARK: - Interstiatial ads management
    
    #if LITE
    private let numberOpeningsKey = "numberOpeningsKey"
    private let showAdsAfterOpenings = 5
    private var adDisplayed = false
    
    private var userDefault: UserDefaults { return UserDefaults.standard }
    
    private var appOpenings: Int {
        get {
            userDefault.integer(forKey: numberOpeningsKey)
        }
        set {
            userDefault.setValue(newValue, forKey: numberOpeningsKey)
        }
    }
    
    
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
