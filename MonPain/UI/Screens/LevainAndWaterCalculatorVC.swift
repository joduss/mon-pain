//
//  FlourAndWaterCalculatorVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 02.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class LevainAndWaterCalculatorVC: CalculatorBaseVC {
    
    private var levainHydratationCell: NumberInputCell!
    private var desiredFlourCell: NumberInputCell!
    private var desiredLevainRatioCell: NumberInputCell!
    private var desiredBreadHydratationCell: NumberInputCell!
    private var desiredSaltCell: FormulateNumberInputCell!
    
    private var ingredientWaterToAddCell: NumberDisplayCell!
    private var ingredientFlourToAddCell: NumberDisplayCell!
    private var ingredientLevainToAddCell: NumberDisplayCell!
    private var ingredientSaltToAddCell: FormulaNumberDisplayCell!
    
    private var totalFlourCell: NumberDisplayCell!
    private var totalWaterCell: NumberDisplayCell!
    private var totalDoughCell: NumberDisplayCell!
    
    private var cells: [[UIView]] = [[]]

    private var saltFormula: IngredientRatioFormula!
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
    
    private func createCells() {
        saltFormula = IngredientRatioFormula(ingredientName: "ingredient.salt",
                                             ingredientRatioTitleKey: "salt.ratio",
                                             ingredient: .addedWater,
                                             calculator: self.calculator)
        saltFormula.decimals = 1
        
        levainHydratationCell = NumberInputCell(ingredientTitleKey: "levain.hydratation", unitTitleKey: "%")
        levainHydratationCell.maxAllowedValue = 200
        levainHydratationCell.value = 100
        levainHydratationCell.showInfoButton = true
        
        desiredFlourCell = NumberInputCell(ingredientTitleKey: "ingredient.flour", unitTitleKey: "g")
        desiredFlourCell.maxAllowedValue = 200
        desiredFlourCell.value = 100
        
        desiredLevainRatioCell = NumberInputCell(ingredientTitleKey: "levain.ratio", unitTitleKey: "%")
        desiredLevainRatioCell.maxAllowedValue = 90
        desiredLevainRatioCell.value = 35
        desiredLevainRatioCell.showInfoButton = true
        
        desiredBreadHydratationCell = NumberInputCell(ingredientTitleKey: "bread.hydratation", unitTitleKey: "%")
        desiredBreadHydratationCell.maxAllowedValue = 200
        desiredBreadHydratationCell.value = 60
        desiredBreadHydratationCell.showInfoButton = true
        
        desiredSaltCell = FormulateNumberInputCell(formula: saltFormula)
        desiredSaltCell.decimal = true
        desiredSaltCell.minAllowedValue = 0
        desiredSaltCell.maxAllowedValue = 100
        desiredSaltCell.showInfoButton = true
        
        // Section 3
        ingredientFlourToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.flour", unitTitleKey: "g")
        ingredientFlourToAddCell.isComputed = true
        
        ingredientWaterToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.water", unitTitleKey: "g")
        ingredientWaterToAddCell.isComputed = true

        ingredientLevainToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.levain", unitTitleKey: "g")
        ingredientLevainToAddCell.isComputed = true
        
        ingredientSaltToAddCell = FormulaNumberDisplayCell(formula: saltFormula)
        ingredientSaltToAddCell.isComputed = true
        ingredientSaltToAddCell.decimals = true

        // Section 4
        totalFlourCell = NumberDisplayCell(ingredientTitleKey: "ingredient.flour", unitTitleKey: "g")
        totalWaterCell = NumberDisplayCell(ingredientTitleKey: "ingredient.water", unitTitleKey: "g")
        totalDoughCell = NumberDisplayCell(ingredientTitleKey: "ingredient.levain", unitTitleKey: "g")
        
        let myCells = [
            [
                levainHydratationCell as UIView
            ],
            [
                desiredFlourCell as UIView,
                desiredLevainRatioCell as UIView,
                desiredBreadHydratationCell as UIView,
                desiredSaltCell as UIView
            ],
            [
                ingredientFlourToAddCell as UIView,
                ingredientLevainToAddCell as UIView,
                ingredientWaterToAddCell as UIView,
                ingredientSaltToAddCell as UIView
            ],
            [
                totalFlourCell as UIView,
                totalWaterCell as UIView,
                totalDoughCell as UIView
            ]
        ]
        
        cells = myCells
        
        for view in cells.reduce([UIView](), { (a, b) in return a + b}) {
            if let cell = view as? NumberInputCell {
                cell.delegate = self
            }
        }
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

extension LevainAndWaterCalculatorVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        guard let cell = dequeuedCell else { return dequeuedCell! }
        let contentView = cell.contentView
        
        contentView.subviews.forEach({$0.removeFromSuperview()})
        
        let subview = cells[indexPath.section][indexPath.row]
        contentView.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        return cell
    }
}

