//
//  TableViewAdManager.swift
//  MonPain
//
//  Created by Jonathan Duss on 14.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TableViewAdManager: NSObject, GADBannerViewDelegate {
    
    private let controller: UIViewController
    private let tableView: UITableView
    private var adview: GADBannerView!
    private let view = UIView()
    
    private var adSize = CGSize.zero
    private var loadedAd = false
    
    public var personalized = false
    
    init(controller: UIViewController, tableView: UITableView) {
        self.controller = controller
        self.tableView = tableView
        super.init()
        prepareView()
    }
    
    private func prepareView() {
        tableView.tableHeaderView = view
        view.clipsToBounds = true
        
        adview = GADBannerView()
        adview.adUnitID = AdsConfiguration.bannerViewUnitId
        adview.delegate = self
        adview.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(tableView.frame.width)
        adSize = adview.adSize.size
        adview.rootViewController = controller
    }
    
    public func didDisappear() {
        adview.removeFromSuperview()
    }
    
    public func didAppear() {
        addAdView()
    }
    
    private func addAdView() {
        adview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adview)
        
        NSLayoutConstraint.activate([
            adview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adview.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        if (!loadedAd) {
            tableView.beginUpdates()
            view.frame.size = CGSize.zero
            tableView.endUpdates()
        }
        
        if self.personalized {
            adview.load(GADRequest())
        }
        else {
            let request = GADRequest()
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
            adview.load(request)
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        loadedAd = true

        tableView.beginUpdates()
        view.frame.size = adSize
        tableView.endUpdates()
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView failed to receive ad with error: \(error)")
            
        loadedAd = false
        
        tableView.beginUpdates()
        view.frame.size = CGSize.zero
        tableView.endUpdates()
    }
}
