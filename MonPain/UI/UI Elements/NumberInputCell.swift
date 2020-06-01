//
//  InputCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

protocol InputCellDelegate {
    func textDidChange(text: String)
}

@IBDesignable
class NumberInputCell: UIView {

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var rightLabel: UILabel!
    
    private let formatter = NumberFormatter()
    
    @IBInspectable
    public var leftLabelTitle: String {
        get {
            return leftLabel?.text ?? ""
        }
        set {
            leftLabel?.text = newValue
        }
    }
    
    public var number: Int {
        return formatter.number(from: textfield?.text ?? "0")?.intValue ?? 0
    }
    
    @IBInspectable
    public var placeholder: String {
        get {
            return textfield.placeholder ?? ""
        }
        set {
            textfield.placeholder = newValue
        }
    }
    
    @IBInspectable
    public var rightLabelTitle: String {
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
        formatter.maximumFractionDigits = 0
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
