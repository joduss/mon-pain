//
//  CalculatorBaseVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 09.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

#if LITE
import UserMessagingPlatform
import AppTrackingTransparency
import AdSupport
#endif

private enum AdType {
    case personalized
    case nonPersonalized
    case none
}

public class CalculatorBaseVC: AdvertisedViewController, UITableViewDataSource, UITableViewDelegate {
    
    #if LITE
    private var adManager: TableViewAdManager!
    #endif
    
    public internal(set) var calculatorType: CalculatorType = .FlourAndWater
    
    @IBOutlet var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
             
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topOutsideTextfield(sender:))))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if LITE
        if (AppConfiguration.shared.shouldDisplayAd()) {
            self.displayInterstitial(adUnitID: AdsConfiguration.interstitialUnitId)
        }
        #endif
    }
    
    #if LITE
    
    public override func configureAdsManager() -> AdsManager? {
        return TableViewAdManager(controller: self, tableView: self.tableView, adContainerView: self.adContainerView!)
    }
    
    #endif
    
    @objc
    private func topOutsideTextfield(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
