//
//  LevainAndWaterCalculator.swift
//  MonPain
//
//  Created by Jonathan Duss on 06.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

class LevainAndWaterCalculator {
    
    // Requirements
    public private(set) var levainHydratation = 1.0
    public private(set) var levainToFlourRatio = 0.35
    public private(set) var breadHydratation = 0.6
    public private(set) var flour = 200.0
    
    // What to do
    public private(set) var waterToAdd = 0.0
    public private(set) var levainToAdd = 0.0
    
    // Intermediate values
    public private(set) var waterInLevain = 0.0
    public private(set) var flourInLevain = 0.0
    
    // Total
    public private(set) var totalWater = 0.0
    public private(set) var totalFlour = 0.0
    public private(set) var totalDough = 0.0
    
    init() {
           updateAddedValues()
       }
       
       public func updateWith(levainHydratationPercent: Double, flour: Double, levainToFlourRatioPercent: Double, breadHydratationPercent: Double) {
           
           self.breadHydratation = breadHydratationPercent / 100
           self.levainToFlourRatio = levainToFlourRatioPercent / 100.0
           self.levainHydratation = levainHydratationPercent / 100.0
           self.flour = flour
           
           updateAddedValues()
       }
       
    private func updateAddedValues() {
        
        // Qty of levain to add = levain ratio * flour
        levainToAdd = levainToFlourRatio * flour
        
        flourInLevain = levainToAdd / (1 + levainHydratation)
        waterInLevain = levainToAdd - flourInLevain
        
        // We know all the total
        totalFlour = flourInLevain + flour
        totalWater = totalFlour * breadHydratation
        
        waterToAdd = totalWater - waterInLevain
        
        totalDough = totalWater + totalFlour
    }
}
