//
//  VPNClientCreationResponse.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 17.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct VPNClientCreationResponse: Codable {
    let message: VPNClient?
    let status: Int
}
