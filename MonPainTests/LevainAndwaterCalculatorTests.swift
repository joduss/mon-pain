//
//  MonPainTests.swift
//  MonPainTests
//
//  Created by Jonathan Duss on 31.05.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import XCTest
@testable import MonPain

class LevainAndwaterCalculatorTests: XCTestCase {
    
    func testCalculation() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let levainHydratation = 60.0
        let levainFlour = 100.0
        let levainWater = 60.0
        let levainToAdd = 160.0 // water + flour of levain
        
        let levainToFlourRatio = 25.0
        let breadHydratation = 75.0
        let flour = 640.0 // qty levain / (levain to flour ratio) ) = 160 / 0.25 = 640
        
        // We already have:
        // - Flour: 100 (from levain) and 240 just added. Total: 340
        // - Water: 60 from levain
        // bread hydratation = (levain water + water to add) / (levain flour + flour added)
        // 0.75 = (60 + water to add) / (100 + 640)
        // water to add = 0.75 * (740) - 60 = 324
        let waterToAdd = 495.0
        
        let totalFlour = flour + levainFlour
        let totalWater = waterToAdd + levainWater
        let totalDough = totalFlour + totalWater
        
        XCTAssertEqual(Float(breadHydratation) / 100, Float(totalWater) / Float(totalFlour))
        
        let calculator = LevainAndWaterCalculator()
        calculator.updateWith(levainHydratationPercent: levainHydratation,
                              flour: flour,
                              levainToFlourRatioPercent: levainToFlourRatio,
                              breadHydratationPercent: breadHydratation)
        
        XCTAssertEqual(waterToAdd, calculator.waterToAdd)
        XCTAssertEqual(levainToAdd, calculator.levainToAdd)
        XCTAssertEqual(flour, calculator.flour)
        
        
        XCTAssertEqual(levainFlour, calculator.flourInLevain)
        XCTAssertEqual(levainWater, calculator.waterInLevain)
        XCTAssertEqual(levainHydratation / 100, calculator.waterInLevain / calculator.flourInLevain)
        
        XCTAssertEqual(totalWater, calculator.totalWater)
        XCTAssertEqual(totalFlour, calculator.totalFlour)
        XCTAssertEqual(totalDough, calculator.totalDough)
        XCTAssertEqual(breadHydratation, 100 * calculator.totalWater / calculator.totalFlour)
    }
    
    func testCalculationTwo() {
        
        let totalDough = 1800.0
        let totalFlour = 1000.0
        let totalWater = 800.0
        let breadHydratation = 0.8
        
        let flour = 900.0
        let water = 750.0
            
        let levainWater = 50.0
        let levainFlour = 100.0
        let levainHydratation = 0.5
        
        let levain = 150.0

        let levainRatio = 150.0 / 900

        
        let calculator = LevainAndWaterCalculator()
        calculator.updateWith(levainHydratationPercent: levainHydratation * 100, flour: flour, levainToFlourRatioPercent: levainRatio * 100, breadHydratationPercent: breadHydratation * 100)
        
        XCTAssertEqual(levain, calculator.levainToAdd, accuracy: 0.0000001)
        XCTAssertEqual(levainHydratation, calculator.levainHydratation, accuracy: 0.0000001)
        XCTAssertEqual(levainRatio, calculator.levainToFlourRatio, accuracy: 0.0000001)
        XCTAssertEqual(breadHydratation, calculator.breadHydratation)
        
        XCTAssertEqual(water, calculator.waterToAdd, accuracy: 0.0000001)
        XCTAssertEqual(flour, calculator.flour, accuracy: 0.0000001)
        
        XCTAssertEqual(levainFlour, calculator.flourInLevain, accuracy: 0.0000001)
        XCTAssertEqual(levainWater, calculator.waterInLevain, accuracy: 0.0000001)
        
        XCTAssertEqual(totalFlour, calculator.totalFlour, accuracy: 0.0000001)
        XCTAssertEqual(totalWater, calculator.totalWater, accuracy: 0.0000001)
        XCTAssertEqual(totalDough, calculator.totalDough, accuracy: 0.0000001)
    }
}
