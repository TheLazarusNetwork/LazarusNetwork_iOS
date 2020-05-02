//
//  NavigationBar.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

struct TitleContent {
    let title: String
    let attributedDescription: NSAttributedString
}

class NavigationBar: UIView {
    @IBInspectable var isBackModeEnabled: Bool = true
    @IBInspectable var isLeftButtonDisabled: Bool = false {
        didSet {
            leftButton.isHidden = isLeftButtonDisabled
            leftButton.isEnabled = !isLeftButtonDisabled
        }
    }
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBOutlet weak var delegate: NavigationBarDelegate?

    @IBOutlet weak fileprivate var titleLabel: UILabel!
    
    @IBOutlet weak fileprivate var leftButton: UIButton!
    
    fileprivate var backButtonState: NavigationBarBackState = .back {
        didSet {
            leftButton.setBackgroundImage(backButtonState.image, for: .normal)
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateDesignOfLeftItem()
    }
    
    @IBAction func backSelected(_ sender: UIButton) {
        delegate?.leftActionSelected(with: self)
    }
    
    func fillTitle(content: String) {
        title = content
    }
    
    private func updateDesignOfLeftItem() {
        guard isLeftButtonDisabled == false else {
            leftButton.setBackgroundImage(UIImage(), for: .normal)
            return
        }
        
        backButtonState = isBackModeEnabled ? .back : .close
    }
}

