//
//  UserDetailed.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

struct UserDetailed: Codable {
    let userName: String
    let fullName: String
    let email: String
    let status: ProfileStatus
    let profileImage: String
}
