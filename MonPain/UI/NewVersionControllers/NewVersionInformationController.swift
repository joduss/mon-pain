//
//  NewVersionInformationController.swift
//  MonPain
//
//  Created by Jonathan Duss on 26.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


class NewVersionInformationSecondaryController {
    
    private let viewController: UIViewController
    
    private var userDefaults: UserDefaults { return UserDefaults.standard }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func displayInfoIfNeeded() {
        
    }
    
    
    // MARK: - check version
    
    private func displayInfoV_1_2() -> Bool {
        let shouldDisplay = AppConfiguration.shared.appOpenings > 1 && userDefaults.bool(forKey: "displayInfoV_1_2")
        user
    }
    
}
