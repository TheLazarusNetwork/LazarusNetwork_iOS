//
//  Domain.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct Domain: Decodable {
    enum CodingKeys: String, CodingKey {
        case domainName
    }
    
    let domainName: String
}
