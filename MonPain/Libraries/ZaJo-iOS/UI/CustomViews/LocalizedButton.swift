//
//  LocalizedButton.swift
//  MonPain
//
//  Created by Jonathan Duss on 14.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class LocalizedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitle(title(for: .normal)?.localized, for: .normal)
    }
    
}
