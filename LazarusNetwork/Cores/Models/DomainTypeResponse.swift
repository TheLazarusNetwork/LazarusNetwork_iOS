//
//  DomainTypeResponse.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct DomainTypeResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
        case types = "message"
    }
    
    let status: Int
    let types: String
}
