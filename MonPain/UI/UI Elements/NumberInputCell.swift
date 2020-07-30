//
//  InputCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

protocol NumberInputCellDelegate: class {
    func textDidChange()
    func displayInfo(controller: UIViewController)
}

@IBDesignable
class NumberInputCell: UIView {

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    private let formatter = NumberFormatter()
    
    public weak var delegate: NumberInputCellDelegate?
    
    @IBInspectable
    public var ingredientTitleKey: String = "" {
        didSet {
            leftLabel?.text = ingredientTitleKey.localized
        }
    }
    
    @IBInspectable
    public var unitTitleKey: String = "" {
        didSet {
            rightLabel?.text = unitTitleKey
        }
    }
    
    @IBInspectable
    public var value: Double = 0 {
        didSet {
            if textfield.isEditing { return }
            textfield.text = formatter.string(from: value)
        }
    }
    
    @IBInspectable
    public var decimal: Bool = false {
        didSet {
            formatter.maximumFractionDigits = decimal ? 1 : 0
            textfield.text = formatter.string(from: value)
            
            textfield.keyboardType = decimal ? .decimalPad : .numberPad
        }
    }
    
    @IBInspectable
    public var minAllowedValue = 1.0
    
    @IBInspectable
    public var maxAllowedValue = Double.greatestFiniteMagnitude
    
    @IBInspectable
    public var showInfoButton: Bool {
        get {
            return infoButton.isHidden
        }
        set {
            infoButton.isHidden = !newValue
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
    
    
    init(ingredientTitleKey: String, unitTitleKey: String) {
        super.init(frame: CGRect.zero)
        loadNib(targetView: self)

        translatesAutoresizingMaskIntoConstraints = false
        
        defer {
            self.ingredientTitleKey = ingredientTitleKey
            self.unitTitleKey = unitTitleKey
        }
        
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        formatter.maximumFractionDigits = 0
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldEditingBegin), for: .editingDidBegin)

        let done = UIBarButtonItem(title: "Ok",
                                   style: .done,
                                   target: self,
                                   action: #selector(closeKeyboard(button:)))
        let group = UIBarButtonItemGroup(barButtonItems: [], representativeItem: done)
        textfield.inputAssistantItem.leadingBarButtonGroups = [group]
    }
    
    @objc
    private func textfieldValueChanged(_ textfield: UITextField) {
        value = doubleValueOf(s: textfield.text ?? "1") ?? 1
        valueChanged()
        delegate?.textDidChange()
    }
    
    @objc
    private func textfieldEditingBegin(_ textfield: UITextField) {
        DispatchQueue.main.async {
            textfield.selectAll(nil)
        }
    }
    
    @objc private func closeKeyboard(button: UIBarButtonItem) {
        textfield.resignFirstResponder()
    }
    
    @objc
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "") {
            value = 0
        }
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        let popup = UIAlertController(title: leftLabel.text,
                                      message: "\(ingredientTitleKey).info".localized,
                                      preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        delegate?.displayInfo(controller: popup)
    }
    
    /// Called when the value changed. Useful when subclassing.
    func valueChanged() { }
    
    
    fileprivate func doubleValueOf(s: String) -> Double? {
        
        // Support of "." and ","
        let cleanedS = s.replacingOccurrences(of: ",", with: formatter.decimalSeparator)
            .replacingOccurrences(of: ".", with: formatter.decimalSeparator)
        
        if let value = formatter.number(from: cleanedS)?.doubleValue {
            return value
        }
        
        if let value = formatter.number(from: "\(cleanedS)0")?.doubleValue {
            return value
        }
        
        return nil
    }
}

extension NumberInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        guard let current = textField.text else {
            return false
        }
        
        let next = (current as NSString).replacingCharacters(in: range, with: string)
        
        guard let number = doubleValueOf(s: next) else {
            return false
        }
        
        return number >= minAllowedValue
            && number <= maxAllowedValue
    }
}
