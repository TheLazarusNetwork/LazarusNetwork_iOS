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
    var name: String
    var email: String
    var enable: Bool
    let ignorePersistentKeepalive: Bool
    let presharedKey: String
    
    let privateKey: String
    let publicKey: String
    let created: Date
    let updated: Date
    
    let address: [String]
    let allowedIPs: [String]
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Strings.DateFormat.dateFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let result = ["id": id,
                      "name": name,
                      "email": email,
                      "enable": enable,
                      "ignorePersistentKeepalive": ignorePersistentKeepalive,
                      "presharedKey": presharedKey,
                      "privateKey": privateKey,
                      "publicKey": publicKey,
                      "created": dateFormatter.string(from: created),
                      "updated": dateFormatter.string(from: updated),
                      "address": address,
                      "allowedIPs": allowedIPs
            ] as [String : Any]
        return result.description
    }
}
