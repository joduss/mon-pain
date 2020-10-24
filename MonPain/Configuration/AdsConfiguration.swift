//
//  AdsConfiguration.swift
//  MonPain
//
//  Created by Jonathan Duss on 14.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

#if LITE
struct AdsConfiguration {
    
    #if DEBUG
    static let bannerViewUnitId = "ca-app-pub-3940256099942544/6300978111"
    static let interstitialUnitId = "ca-app-pub-3940256099942544/1033173712"
    #else
    static let bannerViewUnitId = "ca-app-pub-4180653915602895/4727291574"
    static let interstitialUnitId = "ca-app-pub-4180653915602895/9295467176"
    #endif
}
#endif
