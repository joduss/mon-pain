//
//  FlourAndWaterCalculatorVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 02.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class FlourAndWaterCalculatorVC: CalculatorBaseVC {
    
    @IBOutlet weak var levainHydratationCell: NumberInputCell!
    @IBOutlet weak var desiredLevainCell: NumberInputCell!
    @IBOutlet weak var levainDesiredRatioCell: NumberInputCell!
    @IBOutlet weak var desiredBreadHydratationCell: NumberInputCell!
    
    @IBOutlet weak var waterToAddCell: NumberDisplayCell!
    @IBOutlet weak var flourToAddCell: NumberDisplayCell!
    @IBOutlet weak var levainToAddCell: NumberDisplayCell!

    @IBOutlet weak var totalFlourCell: NumberDisplayCell!
    @IBOutlet weak var totalWaterCell: NumberDisplayCell!
    @IBOutlet weak var totalDoughCell: NumberDisplayCell!
    
    private let calculator = FlourAndWaterCalculator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "screen.flour-and-water.title".localized
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let allCells = [levainHydratationCell, desiredLevainCell, levainDesiredRatioCell, desiredBreadHydratationCell]
        allCells.forEach({$0?.delegate = self})
        
        textDidChange()
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

