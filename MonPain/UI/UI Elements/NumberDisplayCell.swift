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
    
    @IBInspectable
    public var ingredientTitleKey: String {
        get {
            return ingredientLabel?.text ?? ""
        }
        set {
            ingredientLabel?.text = newValue.localized
        }
    }
    
    @IBInspectable
    public var isComputed: Bool = false {
        didSet {
            if isComputed {
                ingredientLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                quantityLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }
            else {
                ingredientLabel.font = UIFont.systemFont(ofSize: 17)
                quantityLabel.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }

    @IBInspectable
    public var value: Double {
        get {
            return formatter.number(from: quantityLabel.text ?? "0")?.doubleValue ?? 0
        }
        set {
            quantityLabel?.text = formatter.string(from: newValue)
        }
    }

    @IBInspectable
    public var UnitTitleKey: String {
        get {
            return unitLabel?.text ?? ""
        }
        set {
            unitLabel?.text = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(targetView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(targetView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        formatter.maximumFractionDigits = 0
    }
}
