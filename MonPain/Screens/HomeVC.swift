//
//  HomeVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
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
