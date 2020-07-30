//
//  UIViewExtension.swift
//  MonPain
//
//  Created by Jonathan Duss on 01.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /// Load the nib from the latest superclass before UIView.
    /// - Parameter targetView: the view in which the loaded view will be added and constraints are set
    /// to make it fill completely. description
    func loadNib(targetView: UIView) {
        
        let uiviewMirror = String(describing: UIView.self)
        
        var m = Mirror(reflecting: self)
        while(String(describing: m.superclassMirror!.subjectType) != uiviewMirror) {
            m = m.superclassMirror!
        }
        
        let fileName = String(describing: m.subjectType)
        let bundle = Bundle(for: type(of: self))
        let nib = bundle.loadNibNamed(fileName, owner: self, options: nil)
        
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
