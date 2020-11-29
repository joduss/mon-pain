//
//  InputCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


@IBDesignable
class NumberDisplayCell: UIView {

    @IBOutlet private weak var ingredientLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    
    private let formatter = NumberFormatter()
    
    /// The ingredient localization key.
    public var ingredientTitleKey: String {
        get {
            return ingredientLabel?.text ?? ""
        }
        set {
            ingredientLabel?.text = newValue.localized
        }
    }
    
    /// Indicates if the cell contains an important information.
    public var isImportant: Bool = false {
        didSet {
            if isImportant {
                ingredientLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                quantityLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                quantityLabel.textColor = UIColor.systemOrange
            }
            else {
                ingredientLabel.font = UIFont.systemFont(ofSize: 17)
                quantityLabel.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }

    /// The quantity of the ingredient.
    public var value: Double {
        get {
            return formatter.number(from: quantityLabel.text ?? "0")?.doubleValue ?? 0
        }
        set {
            quantityLabel?.text = formatter.string(from: newValue)
        }
    }
    
    /// Numbers of decimal the value should be formatted with.
    public var decimals: Bool = false {
        didSet {
            formatter.maximumFractionDigits = decimals ? 1 : 0
            quantityLabel?.text = formatter.string(from: value)
        }
    }

    /// The quantity unit's localization key
    public var unitTitleKey: String {
        get {
            return unitLabel?.text ?? ""
        }
        set {
            unitLabel?.text = newValue
        }
    }
    
    
    // MARK: - Constructors
    // ===============================
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(targetView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(targetView: self)
    }
    
    init(ingredientTitleKey: String, unitTitleKey: String) {
        super.init(frame: CGRect.zero)
        loadNib(targetView: self)

        translatesAutoresizingMaskIntoConstraints = false
        
        defer {
            self.ingredientTitleKey = ingredientTitleKey
            self.unitTitleKey = unitTitleKey
        }
    }
}
