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

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var centerLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    
    private let formatter = NumberFormatter()
    
    @IBInspectable
    public var ingredientTitleKey: String {
        get {
            return leftLabel?.text ?? ""
        }
        set {
            leftLabel?.text = newValue.localized
        }
    }

    @IBInspectable
    public var value: Double {
        get {
            return formatter.number(from: centerLabel.text ?? "0")?.doubleValue ?? 0
        }
        set {
            centerLabel?.text = formatter.string(from: newValue)
        }
    }

    @IBInspectable
    public var UnitTitleKey: String {
        get {
            return rightLabel?.text ?? ""
        }
        set {
            rightLabel?.text = newValue
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
