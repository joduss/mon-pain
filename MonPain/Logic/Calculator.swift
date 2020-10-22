//
//  Calculator.swift
//  MonPain
//
//  Created by Jonathan Duss on 29.07.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

public protocol Calculator {
    
    var waterToAdd: Double { get }
    var totalWater: Double { get }
    var totalFlour: Double { get }
    var flourToAdd: Double { get }
    
    func addFormula(_ formula: IngredientRatioFormula)
}
