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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flourAndWaterButton: TopIconButton!
    @IBOutlet weak var flourAndWaterSubtitle: UILabel!
    @IBOutlet weak var levainAndWaterButton: TopIconButton!
    @IBOutlet weak var levainAndWaterSubtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "home.title".localized
        flourAndWaterButton.setTitle("home.flourWaterButton.title".localized, for: .normal)
        flourAndWaterSubtitle.text = "home.flourWaterButton.subtitle".localized
        levainAndWaterButton.setTitle("home.levainWaterButton.title".localized, for: .normal)
        levainAndWaterSubtitle.text = "home.levainWaterButton.subtitle".localized
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
            .instantiateViewController(identifier: String.init(describing: TabBarController.self)) as? TabBarController
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
