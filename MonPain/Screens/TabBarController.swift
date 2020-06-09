//
//  TabBarController.swift
//  MonPain
//
//  Created by Jonathan Duss on 08.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    public var choice: CalculatorType = .FlourAndWater

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for controller in self.viewControllers ?? [] {
            guard let navController = controller as? UINavigationController else {
                continue
            }
            
            guard let calculatorController = navController.viewControllers.first as? CalculatorBaseVC else {
                continue
            }
            
            if calculatorController.calculatorType == choice {
                self.selectedViewController = calculatorController.parent
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
