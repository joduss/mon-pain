//
//  FlourAndWaterCalculatorVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 02.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class LevainAndWaterCalculatorVC: CalculatorBaseVC {
    
    @IBOutlet weak var levainHydratationCell: NumberInputCell!
    @IBOutlet weak var desiredFlourCell: NumberInputCell!
    @IBOutlet weak var desiredLevainRatioCell: NumberInputCell!
    @IBOutlet weak var desiredBreadHydratationCell: NumberInputCell!
    
    @IBOutlet weak var ingredientWaterToAddCell: NumberDisplayCell!
    @IBOutlet weak var ingredientFlourToAddCell: NumberDisplayCell!
    @IBOutlet weak var ingredientLevainToAddCell: NumberDisplayCell!

    @IBOutlet weak var totalFlourCell: NumberDisplayCell!
    @IBOutlet weak var totalWaterCell: NumberDisplayCell!
    @IBOutlet weak var totalDoughCell: NumberDisplayCell!
    
    private let calculator = LevainAndWaterCalculator()
        
    override func awakeFromNib() {
        title = "screen.levain-and-water.title".localized
        self.calculatorType = .LevainAndWater
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allCells = [levainHydratationCell, desiredLevainRatioCell, desiredFlourCell, desiredBreadHydratationCell]
        allCells.forEach({$0?.delegate = self})
        
        textDidChange()
    }
}

extension LevainAndWaterCalculatorVC : NumberInputCellDelegate {
    
    func textDidChange() {
        calculator.updateWith(levainHydratationPercent: levainHydratationCell.value,
                              flour: desiredFlourCell.value,
                              levainToFlourRatioPercent: desiredLevainRatioCell.value,
                              breadHydratationPercent: desiredBreadHydratationCell.value)
        
        ingredientWaterToAddCell.value = calculator.waterToAdd
        ingredientFlourToAddCell.value = calculator.flour
        ingredientLevainToAddCell.value = calculator.levainToAdd
        
        totalFlourCell.value = calculator.totalFlour
        totalDoughCell.value = calculator.totalDough
        totalWaterCell.value = calculator.totalWater
    }
    
    func displayInfo(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
}

