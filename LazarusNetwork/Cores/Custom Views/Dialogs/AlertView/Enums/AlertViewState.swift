//
//  NavigationBarDelegate.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

enum AlertViewActionType {
    case active
    case destructive
}

extension AlertViewActionType {
    var tintColor: UIColor {
        switch self {
        case .active:
            return UIColor(named: "DarkGreyColor") ?? .darkGray
        
        case .destructive:
            return UIColor(named: "Red") ?? .red
        }
    }
    
    var font: UIFont {
        switch self {
        case .active:
            return UIFont(name: "Montserrat-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
            
        case .destructive:
            return UIFont(name: "Montserrat-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
}
