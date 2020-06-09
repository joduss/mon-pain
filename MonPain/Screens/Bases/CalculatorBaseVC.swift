//
//  CalculatorBaseVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 09.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


public class CalculatorBaseVC: UITableViewController {
    
    public internal(set) var calculatorType: CalculatorType = .FlourAndWater
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topOutsideTextfield(sender:))))
    }
    
    @objc
    private func topOutsideTextfield(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
