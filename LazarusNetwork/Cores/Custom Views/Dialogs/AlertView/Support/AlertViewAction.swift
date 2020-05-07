//
//  NavigationBarDelegate.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

typealias AlertViewCompletion = Model.EmptyOptionalHandler

struct AlertViewAction {
    var title: String
    var style: AlertViewActionType
    var completion: AlertViewCompletion
}

extension AlertViewAction {
    init(buttonName name: String, for style: AlertViewActionType = .active, with completion: AlertViewCompletion = nil) {
        title = name
        self.style = style
        self.completion = completion
    }
}

extension AlertViewAction {
    func toButton(withTag tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = style.font
        button.setTitleColor(style.tintColor, for: .normal)
        
        return button
    }
}
