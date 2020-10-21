//
//  LocalizedSegmentedButton.swift
//  MonPain
//
//  Created by Jonathan Duss on 21.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

class LocalizedSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<numberOfSegments {
            let localizedTitle = titleForSegment(at: i)?.localized
            setTitle(localizedTitle, forSegmentAt: i)
        }
    }
    
}
