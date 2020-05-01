//
//  NavigationControllerEmbedding.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol NavigationControllerEmbedding: class {
    var isFirstInFlow: Bool { get set }
}

extension NavigationControllerEmbedding {
    var isFirstInFlow: Bool {
        return false
    }
}
