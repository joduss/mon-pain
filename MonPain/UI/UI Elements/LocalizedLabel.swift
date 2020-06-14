//
//  LocalizedLabel.swift
//  MonPain
//
//  Created by Jonathan Duss on 14.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class LocalizedLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized
    }
}
