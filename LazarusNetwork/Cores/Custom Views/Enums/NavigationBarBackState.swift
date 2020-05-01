//
//  NavigationBarBackState.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

enum NavigationBarBackState {
    case close
    case back
}

extension NavigationBarBackState {
    var image: UIImage? {
        switch self {
        case .close:
            return UIImage(named: "backArrow")

        case .back:
            return UIImage(named: "backArrow")
        }
    }
}
