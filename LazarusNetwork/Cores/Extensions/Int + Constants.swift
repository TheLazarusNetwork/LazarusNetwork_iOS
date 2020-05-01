//
//  Int + Constants.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

extension Int {
    static let minusOne: Int = -1
    static let zero: Int = 0
    static let one: Int = 1
    static let two: Int = 2
    static let three: Int = 3
    static let ten: Int = 10
    static let undefined: Int = -1
}

extension Int {
    var isZero: Bool {
        return self == .zero
    }
}
