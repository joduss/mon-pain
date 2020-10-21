//
//  AdsManager.swift
//  MonPain
//
//  Created by Jonathan Duss on 23.09.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

public protocol AdsManager: NSObject {
    func stopDisplayingAds()
    func canDisplayAds()
}
