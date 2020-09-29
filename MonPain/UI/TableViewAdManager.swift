//
//  TableViewAdManager.swift
//  MonPain
//
//  Created by Jonathan Duss on 14.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

#if LITE
import UIKit
import GoogleMobileAds

class TableViewAdManager: NSObject, AdsManager, GADBannerViewDelegate {
    
    private let controller: UIViewController
    private let tableView: UITableView
    private var adview: GADBannerView!
    private let view: UIView
    private var heightConstraints: NSLayoutConstraint!
    private var originalInsets: UIEdgeInsets
    
    private var adSize = CGSize.zero
    private var loadedAd = false
    
    init(controller: UIViewController, tableView: UITableView, adContainerView: UIView) {
        self.controller = controller
        self.tableView = tableView
        view = adContainerView
        originalInsets = tableView.contentInset
        super.init()
        prepareView()
    }
    
    private func prepareView() {
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        
        adview = GADBannerView()
        adview.adUnitID = AdsConfiguration.bannerViewUnitId
        adview.delegate = self
        adview.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(tableView.frame.width)
        adSize = adview.adSize.size
        adview.rootViewController = controller
    }
    
    private func addAdView() {
        adview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adview)
        
        NSLayoutConstraint.activate([
            adview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adview.topAnchor.constraint(equalTo: view.topAnchor),
            adview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        adview.load(GADRequest())
    }
    
    
    // MARK: - AdsManager

    public func stopDisplayingAds() {
        adview.removeFromSuperview()
    }
    
    public func canDisplayAds() {
        addAdView()
    }
    
    
    // MARK: - GADBannerViewDelegate
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        // Already loaded. No need to reupdate the content insets/offsets.
        if loadedAd { return }
        
        loadedAd = true
        
        var insets = originalInsets
        insets.top += adSize.height
        tableView.contentInset = insets
        
        var offset = tableView.contentOffset
        offset.y -= adSize.height
        tableView.setContentOffset(offset, animated: true)
    }
        
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView failed to receive ad with error: \(error)")
            
        // Already "not loaded", no need to restore the insets/offsets.
        if !loadedAd { return }
        
        loadedAd = false
        
        tableView.contentInset = originalInsets
        var offset = tableView.contentOffset
        offset.y += adSize.height
        tableView.setContentOffset(offset, animated: true)
    }
}
#endif
