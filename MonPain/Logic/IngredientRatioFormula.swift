//
//  IngredientRatioFormula.swift
//  MonPain
//
//  Created by Jonathan Duss on 29.07.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

public enum Ingredient {
    case totalWater, totalFlour, totalBoudgh, addedWater, addedFlour
}


public class IngredientRatioFormula {
    
    private var calculator: Calculator
    public private(set)var ingredient: Ingredient
    public var ingredientName: String
    public var ingredientRatioTitleKey: String = ""
    public var decimals = 0
    
    /// Desired ratio of the ingredient.
    public var ratio: Double = 0 { didSet { update() }}
    
    /// Quantity of the ingredient to add.
    public private(set) var value: Double = 0
    
    public var onUpdate: (() -> ())?
    
    init(ingredientName: String, ingredient: Ingredient, calculator: Calculator) {
        self.ingredient = ingredient
        self.ingredientName = ingredientName
        self.ingredientRatioTitleKey = ingredientName
        self.calculator = calculator
        calculator.addFormula(self)
        
        update()
    }
    
    init(ingredientName: String, ingredientRatioTitleKey: String, ingredient: Ingredient, calculator: Calculator) {
        self.ingredient = ingredient
        self.ingredientName = ingredientName
        self.ingredientRatioTitleKey = ingredientRatioTitleKey
        self.calculator = calculator
        calculator.addFormula(self)
        
        update()
    }
    
    public func update() {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimals
        
        switch ingredient {
        case .addedWater:
            value = calculator.waterToAdd * ratio / 100.0
        default:
            fatalError("Not implemented")
        }
        
        onUpdate?()
    }
}
