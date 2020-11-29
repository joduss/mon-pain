//
//  FormulateNumberInputCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 29.07.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation
import UIKit

class FormulaNumberInputCell: NumberInputCell {
    
    public private(set) var formula: IngredientRatioFormula
    
    init(formula: IngredientRatioFormula, storageKey: String? = nil) {
        self.formula = formula
        
        super.init(ingredientTitleKey: formula.ingredientRatioTitleKey, unitTitleKey: "%", infoKey: formula.infoKey, storageKey: storageKey)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func valueChanged() {
        super.valueChanged()
        formula.ratio = value
    }
}