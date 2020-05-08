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
        case domainFirewallPassword = "domain_firewall_password"
        case deletedAt = "DeletedAt"
        case updatedAt = "UpdatedAt"
        case domainVpnExternalPort = "domain_vpn_external_port"
        case domainRegion = "domain_region"
        case domainVpnApiUrl = "domain_vpn_api_url"
        case domainFirewallExternalPort = "domain_firewall_external_port"
        case domainAdmin = "domain_admin"
        case domainEmail = "domain_email"
        case domainVpnApiPort = "domain_vpn_api_port"
    }
    
    let id: Int
    let createdAt: Date
    let domainName: String
    let domainUUID: String
    let domainType: String
    let domainStatus: Status
    
    let domainFirewallPassword: String?
    let deletedAt: Date?
    let updatedAt: Date?
    let domainVpnExternalPort: Int
    let domainRegion: String
    let domainVpnApiUrl: String
    let domainFirewallExternalPort: Int
    let domainAdmin: String
    let domainEmail: String
    let domainVpnApiPort: Int

}
