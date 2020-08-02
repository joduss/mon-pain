//
//  TopIconButton.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

@IBDesignable
class TopIconButton: UIControl {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    public var onTap: (() -> ())?
        
    @IBInspectable
    var image: UIImage? {
        get {
            imageView?.image
        }
        set {
            imageView?.image = newValue
        }
    }
    
    @IBInspectable
    var title: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
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
    
    @IBAction func tapped(_ sender: Any) {
        onTap?()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(targetView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(targetView: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        self.sendActions(for: .touchDown)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        if bounds.contains(location) {
            self.sendActions(for: .touchUpInside)
        }
        else {
            self.sendActions(for: .touchUpOutside)
        }
    }
}
