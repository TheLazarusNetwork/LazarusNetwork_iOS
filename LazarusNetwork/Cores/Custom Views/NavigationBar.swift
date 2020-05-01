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

