//
//  InputCell.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit


protocol NumberInputCellDelegate: class {
    
    /// Called when the text changed.
    func textDidChange()
    
    /// Asked the delegate to present the given info view controller.
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
    
    /// The localization key for an information that can be displayed via a (i) button.
    /// If nil, the (i) button is not visible.
    public var infoKey: String?
    
    /// The key used to store a value
    private var storageKey: String?
    
    /// The ingredient localization key.
    public var ingredientTitleKey: String = "" {
        didSet {
            leftLabel?.text = ingredientTitleKey.localized
        }
    }
    
    /// The quantity unit's localization key
    public var unitTitleKey: String = "" {
        didSet {
            rightLabel?.text = unitTitleKey
        }
    }
    
    /// The quantity of the ingredient.
    public var value: Double = 0 {
        didSet {
            valueChanged()
            if textfield.isEditing { return }
            textfield.text = formatter.string(from: value)
        }
    }
    
    /// Numbers of decimal the value should be formatted with.
    public var decimal: Bool = false {
        didSet {
            formatter.maximumFractionDigits = decimal ? 1 : 0
            textfield.text = formatter.string(from: value)
            
            textfield.keyboardType = decimal ? .decimalPad : .numberPad
        }
    }
    
    /// Default 1.0. Supported: 0.0 or 1.0
    public var minAllowedValue = 1.0
    
    public var maxAllowedValue = Double.greatestFiniteMagnitude
    
    public var showInfoButton: Bool {
        get {
            return infoButton.isHidden
        }
        set {
            infoButton.isHidden = !newValue
        }
    }
    
    // MARK: - Initialization
    // ------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(targetView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(targetView: self)
    }
    
    init(ingredientTitleKey: String, unitTitleKey: String, infoKey: String? = nil, storageKey: String? = nil) {
        super.init(frame: CGRect.zero)
        loadNib(targetView: self)

        translatesAutoresizingMaskIntoConstraints = false
        
        self.storageKey = storageKey
        defer {
            self.ingredientTitleKey = ingredientTitleKey
            self.unitTitleKey = unitTitleKey
            self.infoKey = infoKey ?? "\(ingredientTitleKey).info"
        }
        
        configure()
    }
    
    convenience init(ingredientTitleKey: String, unitTitleKey: String, storageKey: String? = nil) {
        self.init(ingredientTitleKey: ingredientTitleKey,
                  unitTitleKey: unitTitleKey,
                  infoKey: nil,
                  storageKey: storageKey)
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
        
        #if !LITE
            restoreValue()
        #endif
    }
    
    
    
    // MARK: - Storage
    
    #if LITE
    
    public func restoreValue() { }
    
    private func storeValue() { }
    
    #else
    
    public func restoreValue() {
        guard let storageKey = self.storageKey else { return }
        
        guard UserDefaults.standard.dictionaryRepresentation().keys.contains(storageKey) else { return }
        
        value = UserDefaults.standard.double(forKey: storageKey)
    }
    
    private func storeValue() {
        guard let storageKey = self.storageKey else { return }
        
        UserDefaults.standard.set(value, forKey: storageKey)
    }
    
    #endif

    
    // MARK: - Info
    // ------------------------------------
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        let popup = UIAlertController(title: leftLabel.text,
                                      message: infoKey!.localized,
                                      preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        delegate?.displayInfo(controller: popup)
    }
    
    // MARK: - For subclassing.
    // ------------------------------------
    
    /// Called when the value changed. Useful when subclassing.
    func valueChanged() { }
    
    
    // MARK: - Utilities
    // ------------------------------------
    
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
    
    // MARK: - Text input
    // ------------------------------------
    
    @objc
    private func textfieldValueChanged(_ textfield: UITextField) {
        value = doubleValueOf(s: textfield.text ?? "1") ?? 1
        storeValue()
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
}
