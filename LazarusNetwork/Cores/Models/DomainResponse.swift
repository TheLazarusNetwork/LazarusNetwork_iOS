//
//  DomainResponse.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 03.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct DomainResponse: Decodable {
    let message: String
    let status: Int
    let total: Int?
    let domain: [Domain]?
}
