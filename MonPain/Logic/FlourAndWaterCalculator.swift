//
//  FlourAndWaterCalculator.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation
import Combine

class FlourAndWaterCalculator: Calculator {
            
    
    // Requirements
    public private(set) var levainHydratation = 1.0
    public private(set) var levainToFlourRatio = 0.35
    public private(set) var breadHydratation = 0.6
    public private(set) var levain = 200.0
    
    // What to do
    public private(set) var waterToAdd = 0.0
    public private(set) var flourToAdd = 0.0
    
    // Intermediate values
    public private(set) var waterInLevain = 0.0
    public private(set) var flourInLevain = 0.0
    
    // Total
    public private(set) var totalWater = 0.0
    public private(set) var totalFlour = 0.0
    public private(set) var totalDough = 0.0
    
    public var formulas: [IngredientRatioFormula] = []
    
    init() {
        updateAddedValues()
    }
    
    public func updateWith(levainHydratationPercent: Double, levainQty: Double, levainToFlourRatioPercent: Double, breadHydratationPercent: Double) {
        
        self.breadHydratation = breadHydratationPercent / 100
        self.levainToFlourRatio = levainToFlourRatioPercent / 100.0
        self.levainHydratation = levainHydratationPercent / 100.0
        self.levain = levainQty
        
        updateAddedValues()
    }
    
    private func updateAddedValues() {
        // levainHydratation = levain water / levain flour ; levainQty = levain water + levain flour
        // levain water = levainHydratation * levain flour
        // ===> levainQty = (levain hydratation * levain flour + levain flour)
        // ===> levainQty = (1 + levain hydratation) * levain flour
        // ===> levain flour = (levainQty) / (1 + levain hydratation)
        flourInLevain = levain / (1 + levainHydratation)
        waterInLevain = levain - flourInLevain
        
        
        let qtyFlourToAdd = levain / levainToFlourRatio
        let qtyWaterToAdd = breadHydratation * (qtyFlourToAdd + flourInLevain) - waterInLevain
        
        flourToAdd = qtyFlourToAdd
        waterToAdd = qtyWaterToAdd
        
        totalWater = qtyWaterToAdd + waterInLevain
        totalFlour = qtyFlourToAdd + flourInLevain
        
        formulas.forEach({$0.update()})
        let addedByFormulas: Double = formulas.reduce(0.0, {$0 + $1.value})

        
        totalDough = qtyWaterToAdd + waterInLevain + qtyFlourToAdd + flourInLevain + addedByFormulas
    }
    
    public func addFormula(_ formula: IngredientRatioFormula) {
        formulas.append(formula)
    }
}
