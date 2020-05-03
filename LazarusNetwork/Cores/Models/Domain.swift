//
//  Domain.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

enum Status: String, Codable {
    case online
    case offline
}

struct Domain: Decodable {
    enum CodingKeys: String, CodingKey {
        case domainName = "domain_name"
        case domainUUID = "domain_uuid"
        case domainType = "domain_type"
        case domainStatus = "domain_status"
        case createdAt = "CreatedAt"
        case id = "ID"
    }
    
    let id: Int
    let createdAt: Date
    let domainName: String
    let domainUUID: String
    let domainType: String
    let domainStatus: Status
}
