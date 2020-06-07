//
//  NumberFormatterExtension.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    func string(from value: Double) -> String? {
        return string(from: NSNumber(value: value))
    }
}
