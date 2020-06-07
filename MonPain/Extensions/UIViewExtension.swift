//
//  UIViewExtension.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

extension UIView {
    func loadNib(targetView: UIView) {
        let bundle = Bundle(for: type(of: self))
        let nib = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
                    
        let nibView = nib?.first as! UIView
        nibView.translatesAutoresizingMaskIntoConstraints = false

        targetView.addSubview(nibView)
        
        NSLayoutConstraint.activate([
            nibView.topAnchor.constraint(equalTo: targetView.topAnchor),
            nibView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor),
            nibView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            nibView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor)
        ])
    }
}
