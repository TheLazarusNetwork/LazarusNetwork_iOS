//
//  UIView+Constraints.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewAndConnectToBounds(childView: UIView) {
        addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["childView": childView]
        
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[childView]-0-|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterY,
                metrics: nil,
                views: views
            )
        )
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[childView]-0-|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
                metrics: nil,
                views: views
            )
        )
    }
}

extension UIView {
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        } set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        } set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get {
            return CGFloat(layer.shadowOpacity)
        } set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }
}
