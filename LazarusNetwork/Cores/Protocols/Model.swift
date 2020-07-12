//
//  Model.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol Model {
    typealias EmptyOptionalHandler = (() -> Void)?
    typealias StringOptionalHandler = ((String) -> Void)?
    typealias TwoStringsOptionalHandler = ((String, String) -> Void)?
}
