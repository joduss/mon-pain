//
//  FormulaNumberDisplayCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 29.07.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation
import UIKit

class FormulaNumberDisplayCell: NumberDisplayCell {
    
    public private(set) var formula: IngredientRatioFormula
    
    init(formula: IngredientRatioFormula) {
        self.formula = formula
        super.init(ingredientTitleKey: formula.ingredientName, unitTitleKey: "g")
        
        formula.onUpdate = { [unowned self] in
            self.update()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    private func update() {
        self.value = formula.value
        self.decimals = formula.decimals != 0
    }
}
