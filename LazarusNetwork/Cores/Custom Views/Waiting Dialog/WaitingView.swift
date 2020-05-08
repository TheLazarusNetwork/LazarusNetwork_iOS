//
//  WaitingView.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 30.04.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class WaitingView: UIView, OnControllerPresentable {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    public func loadNib() -> UIView {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: type(of: self).description().components(separatedBy: ".").last!, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    fileprivate func setupNib() {
        let view = self.loadNib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics:nil, views: bindings))
    }
}
