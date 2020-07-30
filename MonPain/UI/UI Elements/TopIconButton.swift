//
//  TopIconButton.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

@IBDesignable
class TopIconButton: UIButton {
    
    override func layoutSubviews() {
        titleLabel?.sizeToFit()
        super.layoutSubviews()
        
        let padding = CGFloat(10)
        
        let height = self.bounds.height
        let width = self.bounds.width
        
        if let titleLabel = self.titleLabel {
            titleLabel.frame.origin.x = (self.bounds.size.width - titleLabel.frame.size.width) / 2.0
            titleLabel.frame.origin.y = self.bounds.size.height - titleLabel.frame.size.height - padding
        }
        
        let imageViewHeight = height - (titleLabel?.bounds.height ?? 0) - padding - 20
        let imageViewWidth = width
        
        if let imageView = self.imageView {
            imageView.contentMode = .scaleAspectFit
            imageView.frame.origin.x = 0
            imageView.frame.origin.y = padding
            imageView.frame.size = CGSize(width: imageViewWidth, height: imageViewHeight)
        }
        
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 0.65
                }
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            }
        }
    }
    
}
