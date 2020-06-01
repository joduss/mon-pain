//
//  NumberFormatterExtension.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    func string(from value: Int) -> String? {
        return string(from: NSNumber(value: value))
    }
    
    func string(from value: Float) -> String? {
        return string(from: NSNumber(value: value))
    }
}
