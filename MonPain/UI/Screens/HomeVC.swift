//
//  HomeVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {
    
    private let V_1_1_Key = "V_1_1_Key"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flourAndWaterButton: TopIconButton!
    @IBOutlet weak var flourAndWaterSubtitle: UILabel!
    @IBOutlet weak var levainAndWaterButton: TopIconButton!
    @IBOutlet weak var levainAndWaterSubtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "home.title".localized
        flourAndWaterButton.label.text = "home.flourWaterButton.title".localized
        flourAndWaterSubtitle.text = "home.flourWaterButton.subtitle".localized
        levainAndWaterButton.label.text = "home.levainWaterButton.title".localized
        levainAndWaterSubtitle.text = "home.levainWaterButton.subtitle".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        
        #if DEBUG
        defaults.removeObject(forKey: V_1_1_Key)
        #endif
        
        #if LITE
        if !defaults.bool(forKey: V_1_1_Key) {
             defaults.set(true, forKey: V_1_1_Key)
             
             let alert = UIAlertController(title: "home.new_version.title".localized,
                                           message: "home.new_version.message".localized,
                                           preferredStyle: .alert)
             
            alert.addAction(UIAlertAction(title: "home.new_version.action_continue".localized, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "home.new_version.action_buy".localized, style: .default, handler: { _ in
                let store = SKStoreProductViewController()
                store.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: 1525436219)], completionBlock: nil)
                self.present(store, animated: true, completion: nil)
             }))
            
            self.present(alert, animated: true, completion: nil)
        }
        #endif
    }
    
    private var selectedCalculator: CalculatorType = .FlourAndWater
    
    @IBAction func clickedFlourAndWater(_ sender: Any) {
        selectedCalculator = .FlourAndWater
        self.performSegue(withIdentifier: "ToBarBarController", sender: nil)
    }
    
    @IBAction func clickedLevainAndWater(_ sender: Any) {
        selectedCalculator = .LevainAndWater
                self.performSegue(withIdentifier: "ToBarBarController", sender: nil)
    }

    private func transitionTo() {
        guard let tabbarController = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String.init(describing: TabBarController.self)) as? TabBarController
            else { return }
        
        tabbarController.choice = selectedCalculator
        
        let window = UIApplication.shared.windows.first!
        
        window.rootViewController = tabbarController
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .curveEaseInOut,
                          animations: { },
                          completion: nil)
    }
    

}
