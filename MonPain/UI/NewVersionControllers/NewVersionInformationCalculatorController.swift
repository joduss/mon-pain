//
//  NewVersionInformationCalculatorController.swift
//  MonPain
//
//  Created by Jonathan Duss on 26.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


class NewVersionInformationCalculatorController {

    private let viewController: UIViewController

    private var userDefaults: UserDefaults { return UserDefaults.standard }

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func displayInfoIfNeeded() {
        displayInfoV_1_2()
    }


    // MARK: - check version

    private func displayInfoV_1_2(){
        #if DEBUG
            userDefaults.removeObject(forKey: "displayInfoV_1_2")
        #endif

        let shouldDisplay = AppConfiguration.shared.appOpenings > 1 && userDefaults.bool(forKey: "displayInfoV_1_2") == false
        userDefaults.setValue(true, forKey: "displayInfoV_1_2")
        userDefaults.synchronize()

        guard shouldDisplay else { return }

        let alert = UIAlertController(title: "info-new-version.1.2.title".localized, message: "info-new-version.1.2.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "general.ok".localized, style: .default))
        viewController.present(alert, animated: true, completion: nil)
    }

}
