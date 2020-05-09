//
//  VPNClient.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 09.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct VPNClient: Codable {
    let id: String
    let name: String
    let email: String
    var enable: Bool
    let ignorePersistentKeepalive: Bool
    let presharedKey: String
    
    let privateKey: String
    let publicKey: String
    let created: Date
    let updated: Date
    
    let address: [String]
    let allowedIPs: [String]
}
