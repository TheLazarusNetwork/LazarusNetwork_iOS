//
//  User.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

enum ProfileStatus: String, Codable {
    case active
    case inactive
}

enum ProfileResult: String, Codable {
    case success
    case failure
}

struct User: Codable {
    let user: UserDetailed?
    let status: Int
    let authToken: String?
    let result: ProfileResult
    let profileActive: Bool?
    let message: String?
}
