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

class NumberInputCell: UITableViewCell {

    private @IBOutlet weak var leftLabel: UILabel!
    private @IBOutlet weak var textfield: UITextField!
    private @IBOutlet weak var rightLabel: UILabel!
    
    public var leftLabelTitle: String? {
        get {
            return leftLabel.text
        }
        set {
            leftLabel.text = newValue
        }
    }
    
    public var number: String {
        return textfield.text ?? ""
    }
    
    public var rightLabelTitle: String? {
        get {
            return rightLabel.text
        }
        set {
            rightLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
