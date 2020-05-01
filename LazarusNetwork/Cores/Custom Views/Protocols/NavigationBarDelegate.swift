//
//  NavigationBarDelegate.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

@objc protocol NavigationBarDelegate: class {
    func leftActionSelected(with owner: Any)
}
