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
    public var value: Double {
        get {
            return formatter.number(from: textfield?.text ?? "0")?.doubleValue ?? 0
        }
        set {
            textfield.text = formatter.string(from: newValue)
        }
    }
    
    @IBInspectable
    public var minAllowedValue: Int = 0
    
    @IBInspectable
    public var maxAllowedValue: Int = Int.max
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formatter.maximumFractionDigits = 0
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldEditingBegin), for: .editingDidBegin)

        let done = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(closeKeyboard(button:)))
        let group = UIBarButtonItemGroup(barButtonItems: [], representativeItem: done)
        textfield.inputAssistantItem.leadingBarButtonGroups = [group]
    }
    
    @objc
    private func textfieldValueChanged(_ textfield: UITextField) {
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
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        let popup = UIAlertController(title: leftLabel.text,
                                      message: "\(ingredientTitleKey).info".localized,
                                      preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        delegate?.displayInfo(controller: popup)
    }
}

extension NumberInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        guard let current = textField.text else {
            return false
        }
        
        let next = (current as NSString).replacingCharacters(in: range, with: string)
        
        guard let number = formatter.number(from: next)?.intValue else {
            return false
        }
        
        return number >= minAllowedValue
            && number <= maxAllowedValue
    }
}
