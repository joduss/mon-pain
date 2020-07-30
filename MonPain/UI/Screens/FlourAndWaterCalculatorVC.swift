//
//  FlourAndWaterCalculatorVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 02.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class FlourAndWaterCalculatorVC: CalculatorBaseVC {
    
    var levainHydratationCell: NumberInputCell!
    var desiredLevainCell: NumberInputCell!
    var levainDesiredRatioCell: NumberInputCell!
    var desiredBreadHydratationCell: NumberInputCell!
    var desiredSaltCell: NumberInputCell!

    var waterToAddCell: NumberDisplayCell!
    var flourToAddCell: NumberDisplayCell!
    var levainToAddCell: NumberDisplayCell!
    var saltToAddCell: NumberDisplayCell!

    var totalFlourCell: NumberDisplayCell!
    var totalWaterCell: NumberDisplayCell!
    var totalDoughCell: NumberDisplayCell!
    
    private let calculator = FlourAndWaterCalculator()
    
    private var cells: [[UIView]] = [[]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "screen.flour-and-water.title".localized
    }
    
    //TODO: Dynamic TVC with cells definedd programmatically!
    
    private var saltFormula: IngredientRatioFormula!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saltFormula = IngredientRatioFormula(ingredientName: "ingredient.salt", ingredient: .addedWater, calculator: self.calculator)
        saltFormula.decimals = 1
        
        levainHydratationCell = NumberInputCell(ingredientTitleKey: "levain.hydratation", unitTitleKey: "%")
        levainHydratationCell.maxAllowedValue = 200
        levainHydratationCell.value = 100
        levainHydratationCell.showInfoButton = true
        
        desiredLevainCell = NumberInputCell(ingredientTitleKey: "ingredient.levain", unitTitleKey: "g")
        desiredLevainCell.maxAllowedValue = 200
        desiredLevainCell.value = 100
        
        levainDesiredRatioCell = NumberInputCell(ingredientTitleKey: "levain.ratio", unitTitleKey: "%")
        levainDesiredRatioCell.maxAllowedValue = 90
        levainDesiredRatioCell.value = 35
        levainDesiredRatioCell.showInfoButton = true
        
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
        flourToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.flour", unitTitleKey: "g")
        flourToAddCell.isComputed = true
        
        waterToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.water", unitTitleKey: "g")
        waterToAddCell.isComputed = true

        levainToAddCell = NumberDisplayCell(ingredientTitleKey: "ingredient.levain", unitTitleKey: "g")
        levainToAddCell.isComputed = true
        
        saltToAddCell = FormulaNumberDisplayCell(formula: saltFormula)
        saltToAddCell.isComputed = true
        saltToAddCell.decimals = true

        // Section 4
        totalFlourCell = NumberDisplayCell(ingredientTitleKey: "ingredient.flour", unitTitleKey: "g")
        totalWaterCell = NumberDisplayCell(ingredientTitleKey: "ingredient.water", unitTitleKey: "g")
        totalDoughCell = NumberDisplayCell(ingredientTitleKey: "ingredient.levain", unitTitleKey: "g")
        
        let myCells = [
            [
                levainHydratationCell as UIView
            ],
            [
                desiredLevainCell as UIView,
                levainDesiredRatioCell as UIView,
                desiredBreadHydratationCell as UIView,
                desiredSaltCell as UIView
            ],
            [
                flourToAddCell as UIView,
                waterToAddCell as UIView,
                levainToAddCell as UIView,
                saltToAddCell as UIView
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

        textDidChange()
    }
    
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "header.my_dear_levain".localized
        case 1:
            return "header.i_want".localized
        case 2:
            return "header.must_add".localized
        case 3:
            return "header.total".localized
        default:
            return ""
        }
    }
}

extension FlourAndWaterCalculatorVC : NumberInputCellDelegate {
    
    func textDidChange() {
        calculator.updateWith(levainHydratationPercent: levainHydratationCell.value,
                              levainQty: desiredLevainCell.value,
                              levainToFlourRatioPercent: levainDesiredRatioCell.value,
                              breadHydratationPercent: desiredBreadHydratationCell.value)
        
        waterToAddCell.value = calculator.waterToAdd
        flourToAddCell.value = calculator.flourToAdd
        levainToAddCell.value = calculator.levain
        
        totalFlourCell.value = calculator.totalFlour
        totalDoughCell.value = calculator.totalDough
        totalWaterCell.value = calculator.totalWater
    }
    
    func displayInfo(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
}

