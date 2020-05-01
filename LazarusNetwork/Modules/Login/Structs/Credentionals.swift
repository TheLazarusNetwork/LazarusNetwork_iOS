//
//  Credentionals.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct Credentionals {
    let login: String
    let password: String
}

extension Credentionals: Equatable {
    static func == (lhs: Credentionals, rhs: Credentionals) -> Bool {
        return lhs.login == rhs.login && lhs.password == rhs.password
    }
}
