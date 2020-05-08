//
//  DomainCreateResponse.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct DomainCreateResponse: Decodable {
    let message: String
    let status: Int
    let domain: Domain?
}
